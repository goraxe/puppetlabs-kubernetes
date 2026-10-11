# frozen_string_literal: true

require 'spec_helper'
describe 'kubernetes::repos', type: :class do
  context 'with osfamily => Ubuntu and manage_docker => true' do
    let(:facts) do
      {
        osfamily: 'Debian', # needed to run dependent tests from fixtures puppetlabs-apt
        kernel: 'Linux',
        os: {
          family: 'Debian',
          name: 'Ubuntu',
          release: {
            full: '16.04'
          },
          distro: {
            codename: 'xenial'
          }
        }
      }
    end
    let(:params) do
      {
        'container_runtime' => 'docker',
        'kubernetes_apt_location' => 'http://apt.kubernetes.io',
        'kubernetes_apt_release' => 'kubernetes-xenial',
        'kubernetes_apt_repos' => 'main',
        'kubernetes_key_id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
        'kubernetes_key_source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
        'kubernetes_yum_baseurl' => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
        'kubernetes_yum_gpgkey' => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        'docker_apt_location' => 'https://download.docker.com/linux/ubuntu',
        'docker_apt_release' => 'xenial',
        'docker_apt_repos' => 'main',
        'docker_yum_baseurl' => 'https://download.docker.com/linux/centos/7/x86_64/stable',
        'docker_yum_gpgkey' => 'https://download.docker.com/linux/centos/gpg',
        'docker_key_id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'docker_key_source' => 'https://download.docker.com/linux/ubuntu/gpg',
        'containerd_install_method' => 'archive',
        'create_repos' => true,
        'manage_docker' => true
      }
    end

    it {
      expect(subject).to contain_apt__source('kubernetes').with(
        ensure: 'present',
        location: 'http://apt.kubernetes.io',
        repos: 'main',
        release: 'kubernetes-xenial',
        key: { 'id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB', 'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' },
      )
    }

    it {
      expect(subject).to contain_apt__source('docker').with(
        ensure: 'present',
        location: 'https://download.docker.com/linux/ubuntu',
        repos: 'main',
        release: 'xenial',
        key: { 'id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88', 'source' => 'https://download.docker.com/linux/ubuntu/gpg' },
      )
    }
  end

  context 'with osfamily => Ubuntu and container_runtime => cri_containerd and containerd_install_method => package' do
    let(:facts) do
      {
        osfamily: 'Debian', # needed to run dependent tests from fixtures puppetlabs-apt
        kernel: 'Linux',
        os: {
          family: 'Debian',
          name: 'Ubuntu',
          release: {
            full: '16.04'
          },
          distro: {
            codename: 'xenial'
          }
        }
      }
    end
    let(:params) do
      {
        'container_runtime' => 'cri_containerd',
        'kubernetes_apt_location' => 'http://apt.kubernetes.io',
        'kubernetes_apt_release' => 'kubernetes-xenial',
        'kubernetes_apt_repos' => 'main',
        'kubernetes_key_id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
        'kubernetes_key_source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
        'kubernetes_yum_baseurl' => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
        'kubernetes_yum_gpgkey' => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        'docker_apt_location' => 'https://download.docker.com/linux/ubuntu',
        'docker_apt_release' => 'xenial',
        'docker_apt_repos' => 'main',
        'docker_yum_baseurl' => 'https://download.docker.com/linux/centos/7/x86_64/stable',
        'docker_yum_gpgkey' => 'https://download.docker.com/linux/centos/gpg',
        'docker_key_id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'docker_key_source' => 'https://download.docker.com/linux/ubuntu/gpg',
        'containerd_install_method' => 'package',
        'create_repos' => true,
        'manage_docker' => true
      }
    end

    it {
      expect(subject).to contain_apt__source('kubernetes').with(
        ensure: 'present',
        location: 'http://apt.kubernetes.io',
        repos: 'main',
        release: 'kubernetes-xenial',
        key: { 'id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB', 'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' },
      )
    }

    it {
      expect(subject).to contain_apt__source('docker').with(
        ensure: 'present',
        location: 'https://download.docker.com/linux/ubuntu',
        repos: 'main',
        release: 'xenial',
        key: { 'id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88', 'source' => 'https://download.docker.com/linux/ubuntu/gpg' },
      )
    }
  end

  context 'with osfamily => RedHat and manage_epel => true and manage_docker => false' do
    let(:facts) do
      {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemrelease: '7.0',
        kernel: 'Linux',
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: {
            full: '7.0'
          }
        }
      }
    end

    let(:params) do
      {
        'container_runtime' => 'docker',
        'kubernetes_apt_location' => 'http://apt.kubernetes.io',
        'kubernetes_apt_release' => 'kubernetes-xenial',
        'kubernetes_apt_repos' => 'main',
        'kubernetes_key_id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
        'kubernetes_key_source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
        'kubernetes_yum_baseurl' => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
        'kubernetes_yum_gpgkey' => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        'docker_apt_location' => 'https://download.docker.com/linux/ubuntu',
        'docker_apt_release' => 'xenial',
        'docker_apt_repos' => 'main',
        'docker_yum_baseurl' => 'https://download.docker.com/linux/centos/7/x86_64/stable',
        'docker_yum_gpgkey' => 'https://download.docker.com/linux/centos/gpg',
        'docker_key_id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'docker_key_source' => 'https://download.docker.com/linux/ubuntu/gpg',
        'containerd_install_method' => 'archive',
        'create_repos' => true,
        'manage_docker' => false
      }
    end

    it { is_expected.not_to contain_yumrepo('docker') }
    it { is_expected.to contain_yumrepo('kubernetes') }
  end

  context 'with osfamily => RedHat and container_runtime => cri_containerd and containerd_install_method => package' do
    let(:facts) do
      {
        operatingsystem: 'RedHat',
        osfamily: 'RedHat',
        operatingsystemrelease: '7.0',
        kernel: 'Linux',
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: {
            full: '7.0'
          }
        }
      }
    end

    let(:params) do
      {
        'container_runtime' => 'cri_containerd',
        'kubernetes_apt_location' => 'http://apt.kubernetes.io',
        'kubernetes_apt_release' => 'kubernetes-xenial',
        'kubernetes_apt_repos' => 'main',
        'kubernetes_key_id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
        'kubernetes_key_source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
        'kubernetes_yum_baseurl' => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
        'kubernetes_yum_gpgkey' => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        'docker_apt_location' => 'https://download.docker.com/linux/ubuntu',
        'docker_apt_release' => 'xenial',
        'docker_apt_repos' => 'main',
        'docker_yum_baseurl' => 'https://download.docker.com/linux/centos/7/x86_64/stable',
        'docker_yum_gpgkey' => 'https://download.docker.com/linux/centos/gpg',
        'docker_key_id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'docker_key_source' => 'https://download.docker.com/linux/ubuntu/gpg',
        'containerd_install_method' => 'package',
        'create_repos' => true,
        'manage_docker' => false
      }
    end

    it { is_expected.to contain_yumrepo('docker') }
    it { is_expected.to contain_yumrepo('kubernetes') }
  end

  # Debian 13 has no apt-key (apt 3.0): the Docker repo is signed with a keyring
  # file there. Debian 12 keeps the apt::key path, so its catalog is unchanged.
  [
    { release: '13', codename: 'trixie' },
    { release: '12', codename: 'bookworm' },
  ].each do |debian|
    context "with Debian #{debian[:release]} and container_runtime => cri_containerd and containerd_install_method => package" do
      let(:facts) do
        {
          osfamily: 'Debian', # needed to run dependent tests from fixtures puppetlabs-apt
          kernel: 'Linux',
          os: {
            family: 'Debian',
            name: 'Debian',
            release: {
              full: "#{debian[:release]}.1",
              major: debian[:release]
            },
            distro: {
              codename: debian[:codename]
            }
          }
        }
      end
      let(:params) do
        {
          'container_runtime' => 'cri_containerd',
          'kubernetes_apt_location' => 'https://pkgs.k8s.io/core:/stable:/v1.35/deb/',
          'kubernetes_apt_release' => '/',
          'kubernetes_apt_repos' => 'main',
          'kubernetes_key_id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
          'kubernetes_key_source' => 'https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key',
          'kubernetes_yum_baseurl' => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
          'kubernetes_yum_gpgkey' => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
          'docker_apt_location' => 'https://download.docker.com/linux/debian/',
          'docker_apt_release' => debian[:codename],
          'docker_apt_repos' => 'stable',
          'docker_yum_baseurl' => 'https://download.docker.com/linux/centos/7/x86_64/stable',
          'docker_yum_gpgkey' => 'https://download.docker.com/linux/centos/gpg',
          'docker_key_id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
          'docker_key_source' => 'https://download.docker.com/linux/debian/gpg',
          'containerd_install_method' => 'package',
          'create_repos' => true,
          'manage_docker' => true
        }
      end

      it { is_expected.to contain_apt__keyring('kubernetes-keyring.asc') }
      it { is_expected.to contain_apt__source('docker').with(ensure: 'present', release: debian[:codename]) }

      if debian[:release] == '13'
        it 'signs the Docker repo with a keyring file' do
          is_expected.to contain_apt__keyring('docker.asc')
            .with(dir: '/etc/apt/keyrings', source: 'https://download.docker.com/linux/debian/gpg')
          is_expected.to contain_apt__source('docker')
            .with_keyring('/etc/apt/keyrings/docker.asc')
            .without_key
            .that_requires('Apt::Keyring[docker.asc]')
        end
      else
        it 'keeps the apt::key path' do
          is_expected.to contain_apt__source('docker').with_key(
            'id' => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
            'source' => 'https://download.docker.com/linux/debian/gpg',
          ).without_keyring
          is_expected.not_to contain_apt__keyring('docker.asc')
        end
      end
    end
  end
end
