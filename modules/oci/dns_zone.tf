resource "oci_dns_zone" "dns_zone" {
  compartment_id = oci_identity_compartment.compartment.id
  name           = var.dns_name
  zone_type      = "PRIMARY"
}