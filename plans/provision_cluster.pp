# @summary Provisions machines
#
# Provisions machines for integration testing
#
# @param image_type
#   The platform handed to the provisioner. For the docker provisioner this is
#   an image name, for example `debian:12`.
# @param provision_type
#   The provision module task to use (`docker`, `vagrant`, `provision_service`).
# @param inventory
#   Inventory file the provisioner records the machines in. When unset the
#   provisioner picks its own default, which is not where litmus looks.
# @param roles
#   One machine is provisioned per role, tagged with the `role` var.
#
# @example
#   kubernetes::provision_cluster
plan kubernetes::provision_cluster(
  Optional[String] $image_type = 'debian:12',
  Optional[String] $provision_type = 'provision_service',
  Array[String[1]] $roles = ['controller', 'worker1', 'worker2'],
  Optional[String[1]] $inventory = undef,
) {
  $roles.each |$role| {
    run_task("provision::${provision_type}", 'localhost', action => 'provision', platform => $image_type, vars => "role: ${role}", inventory => $inventory)
  }
}
