resource "oci_core_vcn" "vcn" {
  cidr_blocks = [
    "10.0.0.0/16"
  ]
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-vcn"
  dns_label      = "vcn${substr(sha256("${var.compartment_name}-cluster"), 0, 6)}"
  is_ipv6enabled = false
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-internet-gateway"
  enabled        = true
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_nat_gateway" "nat_gateway" {
  block_traffic  = false
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-nat-gateway"
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-service-gateway"
  services {
    service_id = data.oci_core_services.services.services.0.id
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "oke-public-routetable-cluster1-0a9b4790d"
  route_rules {
    description       = "traffic to/from internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "private_route_table" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "oke-private-routetable-cluster1-0a9b4790d"
  route_rules {
    description       = "traffic to OCI services"
    destination       = "all-ams-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_security_list" "service_load_balancer_security_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-load-balancer-security-list"
  vcn_id         = oci_core_vcn.vcn.id
  lifecycle {
    ignore_changes = all
  }
}

resource "oci_core_security_list" "node_security_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-node-security-list"
  egress_security_rules {
    description      = "Access to Kubernetes API Endpoint"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = false
    tcp_options {
      max = 6443
      min = 6443
    }
  }
  egress_security_rules {
    description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    destination      = "all-ams-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = false
    tcp_options {
      max = 443
      min = 443
    }
  }
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  egress_security_rules {
    description      = "ICMP Access from Kubernetes Control Plane"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = 4
      type = 3
    }
    protocol  = "1"
    stateless = false
  }
  egress_security_rules {
    description      = "Kubernetes worker to control plane communication"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = false
    tcp_options {
      max = 12250
      min = 12250
    }
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = 4
      type = 3
    }
    protocol  = "1"
    stateless = false
  }
  egress_security_rules {
    description      = "Worker Nodes access to Internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
    protocol    = "all"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    description = "Inbound SSH traffic to worker nodes"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = 4
      type = 3
    }
    protocol    = "1"
    source      = "10.0.0.0/28"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  ingress_security_rules {
    description = "TCP access from Kubernetes Control Plane"
    protocol    = "6"
    source      = "10.0.0.0/28"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  vcn_id = oci_core_vcn.vcn.id
  lifecycle {
    ignore_changes = all
  }
}

resource "oci_core_security_list" "kubernetes_api_endpoint_security_list" {
  compartment_id = oci_identity_compartment.compartment.id
  display_name   = "${var.compartment_name}-kubernetes-api-endpoint-security-list"
  egress_security_rules {
    description      = "All traffic to worker nodes"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = false
  }
  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = "all-ams-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = false
    tcp_options {
      max = 443
      min = 443
    }
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = 4
      type = 3
    }
    protocol  = "1"
    stateless = false
  }
  ingress_security_rules {
    description = "External access to Kubernetes API endpoint"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 6443
      min = 6443
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    protocol    = "6"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 6443
      min = 6443
    }
  }
  ingress_security_rules {
    description = "Kubernetes worker to control plane communication"
    protocol    = "6"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 12250
      min = 12250
    }
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = 4
      type = 3
    }
    protocol    = "1"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
  }
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "service_load_balancer_subnet" {
  cidr_block                 = "10.0.20.0/24"
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.compartment_name}-service-load-balancer-subnet"
  dns_label                  = "sbnt${substr(sha256("${var.compartment_name}-service-load-balancer-subnet"), 0, 6)}"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_security_list.service_load_balancer_security_list.id
  ]
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "node_subnet" {
  cidr_block                 = "10.0.10.0/24"
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.compartment_name}-node-subnet"
  dns_label                  = "sbnt${substr(sha256("${var.compartment_name}-node-subnet"), 0, 6)}"
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.private_route_table.id
  security_list_ids = [
    oci_core_security_list.node_security_list.id
  ]
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
  cidr_block                 = "10.0.0.0/28"
  compartment_id             = oci_identity_compartment.compartment.id
  display_name               = "${var.compartment_name}-kubernetes-api-endpoint-subnet"
  dns_label                  = "sbnt${substr(sha256("${var.compartment_name}-kubernetes-api-endpoint-subnet"), 0, 6)}"
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids = [
    oci_core_security_list.kubernetes_api_endpoint_security_list.id
  ]
  vcn_id = oci_core_vcn.vcn.id
}
