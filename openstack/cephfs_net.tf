data "openstack_networking_network_v2" "cephfs" {
  name = "CephFS-Network"
}

data "openstack_networking_network_v2" "cephfs2" {
  name = "CephFS2-Network"
}

locals {
  ceph_instances = {
    for name, instance in module.design.instances :
      name => instance
      if contains(instance.tags, "cephfs") || contains(instance.tags, "cephfs2")
  }

  ceph_instances_to_build = {
    for name, instance in module.design.instances_to_build :
      name => instance
      if contains(keys(local.ceph_instances), name)
  }
}

resource "openstack_networking_port_v2" "nic_ceph" {
  for_each           = local.ceph_instances
  name               = format("%s-%s-ceph-port", var.cluster_name, each.key)
  network_id         = contains(each.value.tags, "cephfs") ? data.openstack_networking_network_v2.cephfs.id : data.openstack_networking_network_v2.cephfs2.id
  security_group_ids = concat(
    [
      openstack_networking_secgroup_v2.global.id
    ],
    [
      for tag, value in openstack_networking_secgroup_v2.external: value.id if contains(each.value.tags, tag)
    ]
  )
}

resource "openstack_compute_interface_attach_v2" "extra_network" {
  for_each    = local.ceph_instances_to_build
  instance_id = openstack_compute_instance_v2.instances[each.key].id
  port_id     = openstack_networking_port_v2.nic_ceph[each.key].id
}
