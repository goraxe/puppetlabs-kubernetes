# frozen_string_literal: true

require 'spec_helper_acceptance'

# Reduced acceptance scope for hosted CI: one systemd container per Debian
# release. It applies the module with a worker role (packages, containerd,
# kubelet unit, kubeadm join config) and asserts on the result. It does not
# form a cluster: kubeadm init/join, CNI and workloads need real VMs.
describe 'the Kubernetes module on a Debian container', :smoke do
  # apply_manifest truncates the puppet output in its exception message, so
  # print it in full before re-raising.
  def apply_verbose(manifest, opts = {})
    apply_manifest(manifest, opts)
  rescue RuntimeError => e
    puts e.message
    raise
  end

  k8s_minor = 'v1.33'

  pp = <<~MANIFEST
    class { 'kubernetes':
      worker                     => true,
      api_server_count           => 1,
      kubernetes_version         => '1.33.0',
      kubernetes_package_version => 'present',
      controller_address         => '192.0.2.10:6443',
      token                      => 'abcdef.0123456789abcdef',
      discovery_token_hash       => '0000000000000000000000000000000000000000000000000000000000000000',
      container_runtime          => 'cri_containerd',
      containerd_install_method  => 'package',
      containerd_package_name    => 'containerd',
      containerd_version         => 'present',
      manage_docker              => false,
      manage_etcd                => false,
      # The apt repo is set up below (pkgs.k8s.io is a flat repo that
      # kubernetes::repos cannot express).
      create_repos               => false,
      # No kernel modules in a container; the runner kernel provides them.
      manage_kernel_modules      => false,
      manage_sysctl_settings     => false,
      cgroup_driver              => 'systemd',
    }

    # There is no API server to join. Everything up to the join is applied for
    # real; the join itself is skipped.
    Exec <| title == 'kubeadm join' |> {
      unless => 'true',
    }
  MANIFEST

  before(:all) do
    run_shell('apt-get update -qq && apt-get install -y -qq curl gnupg ca-certificates')
    run_shell('mkdir -p /etc/apt/keyrings && touch /etc/fstab')
    run_shell("curl -fsSL https://pkgs.k8s.io/core:/stable:/#{k8s_minor}/deb/Release.key | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg")
    run_shell("echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/#{k8s_minor}/deb/ /' > /etc/apt/sources.list.d/kubernetes.list")
    run_shell('apt-get update -qq')
  end

  it 'applies without errors' do
    expect { apply_verbose(pp) }.not_to raise_error
  end

  it 'applies idempotently' do
    expect { apply_verbose(pp, catch_changes: true) }.not_to raise_error
  end

  ['kubelet', 'kubeadm', 'kubectl', 'containerd'].each do |pkg|
    it "installs #{pkg}" do
      run_shell("dpkg-query -W -f='${Status}' #{pkg}") do |r|
        expect(r.stdout).to match(%r{install ok installed})
      end
    end
  end

  it 'installs the Kubernetes minor release the repository pins' do
    run_shell('kubeadm version -o short') do |r|
      expect(r.stdout).to match(%r{^v1\.33\.})
    end
  end

  it 'writes the kubeadm join config' do
    run_shell('cat /etc/kubernetes/config.yaml') do |r|
      expect(r.stdout).to match(%r{kind: JoinConfiguration})
      expect(r.stdout).to match(%r{192\.0\.2\.10:6443})
    end
  end

  it 'configures containerd for the systemd cgroup driver' do
    run_shell('cat /etc/containerd/config.toml') do |r|
      expect(r.stdout).to match(%r{SystemdCgroup = true})
    end
  end

  it 'runs containerd' do
    run_shell('systemctl status containerd --no-pager; journalctl -u containerd --no-pager | tail -40', expect_failures: true) do |r|
      puts r.stdout
    end
    run_shell('systemctl is-active containerd') do |r|
      expect(r.stdout).to match(%r{^active$})
    end
  end

  it 'enables kubelet' do
    run_shell('systemctl is-enabled kubelet') do |r|
      expect(r.stdout).to match(%r{^enabled$})
    end
  end
end
