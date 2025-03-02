resource "oci_containerengine_cluster" "cluster" {
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  compartment_id = oci_identity_compartment.compartment.id
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.kubernetes_api_endpoint_subnet.id
  }
  image_policy_config {
    is_policy_enabled = false
  }
  kubernetes_version = var.kubernetes_version
  name               = "${var.compartment_name}-cluster"
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_subnet_ids = [
      oci_core_subnet.service_load_balancer_subnet.id
    ]
  }
  type   = "BASIC_CLUSTER"
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id     = oci_containerengine_cluster.cluster.id
  compartment_id = oci_identity_compartment.compartment.id
  initial_node_labels {
    key   = "name"
    value = "${var.compartment_name}-cluster"
  }
  kubernetes_version = var.kubernetes_version
  name               = "${var.compartment_name}-node-pool"
  node_config_details {
    is_pv_encryption_in_transit_enabled = false
    node_pool_pod_network_option_details {
      cni_type          = "OCI_VCN_IP_NATIVE"
      max_pods_per_node = 31
      pod_subnet_ids = [
        oci_core_subnet.node_subnet.id
      ]
    }
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    size = 2
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration              = "PT1H"
    is_force_delete_after_grace_duration = false
  }
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }
  node_source_details {
    boot_volume_size_in_gbs = "50"
    image_id                = var.node_image_id
    source_type             = "IMAGE"
  }
}
