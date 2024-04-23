resource "openstack_compute_interface_attach_v2" "extra_network" {
  for_each    = module.design.instances_to_build
  instance_id = openstack_compute_instance_v2.instances[each.key].id
  network_id  = "00b327b4-4fb2-4ed8-a7f2-6ff49e3b7e7c"
}
