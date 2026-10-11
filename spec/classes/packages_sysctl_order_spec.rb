# frozen_string_literal: true

require 'spec_helper'

# augeasproviders_sysctl snapshots the valid keys once per run, when the first
# Sysctl of ANY class is evaluated, so br_netfilter must load before all of them.
describe 'kubernetes::packages', type: :class do # rubocop:disable RSpec/DescribeClass
  let(:pre_condition) do
    [
      'include kubernetes',
      'include kubernetes::config::kubeadm',
      'exec { \'kubernetes-systemd-reload\': command => \'/bin/true\' }',
      'archive{ \'etcd-archive\': }',
      'service { \'containerd\': }',
      # a sysctl declared elsewhere in the catalog (profile::oomd and friends)
      'sysctl { \'vm.swappiness\': value => \'10\' }',
    ]
  end
  let(:facts) do
    {
      kernel: 'Linux',
      networking: { hostname: 'foo' },
      os: { family: 'Debian', name: 'Debian', release: { full: '12', major: '12' }, distro: { codename: 'bookworm' } },
      ec2_metadata: { hostname: 'ip-10-10-10-1.ec2.internal' }
    }
  end
  let(:params) do
    {
      'manage_kernel_modules' => true,
      'manage_sysctl_settings' => true,
      'manage_etcd' => false,
      'container_runtime' => 'cri_containerd',
      'containerd_install_method' => 'package',
      'create_repos' => false,
      'disable_swap' => false
    }
  end

  it { is_expected.to contain_kmod__load('br_netfilter').that_comes_before('Sysctl[net.bridge.bridge-nf-call-iptables]') }
  it { is_expected.to contain_kmod__load('br_netfilter').that_comes_before('Sysctl[vm.swappiness]') }
end
