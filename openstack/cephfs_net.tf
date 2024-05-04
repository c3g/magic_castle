resource "openstack_networking_port_v2" "nic_ceph" {
  for_each           = module.design.instances
  name               = format("%s-%s-ceph-port", var.cluster_name, each.key)
  network_id         = "00b327b4-4fb2-4ed8-a7f2-6ff49e3b7e7c"
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
  for_each    = module.design.instances_to_build
  instance_id = openstack_compute_instance_v2.instances[each.key].id
  port_id     = "openstack_networking_port_v2.nic_ceph[each.key].id"
}
