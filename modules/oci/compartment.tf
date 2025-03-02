resource "oci_identity_compartment" "compartment" {
  description = "This is the ${var.compartment_name} compartment"
  name        = var.compartment_name
}
