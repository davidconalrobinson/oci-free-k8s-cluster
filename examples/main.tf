module "oci_free_k8s_cluster" {
    source = "github.com/davidconalrobinson/oci-free-k8s-cluster"

    tenancy_ocid        = "ocid1.tenancy.oc1..thisisafaketenancyocid"
    fingerprint         = "th:is:is:af:ak:ef:in:ge:rp:ri:nt"
    user_ocid           = "ocid1.user.oc1..thisisafakeuserocid"
    private_key_path    = "/path/to/oci/private-key.pem"
    region              = "eu-amsterdam-1"
    dns_name            = "example.com"
    availability_domain = "chxt:eu-amsterdam-1-AD-1"
    node_image_id       = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaafzh7gzsjes6na6rebvxtgs7ldp5qcjegal5y76ouhut4prih4y5q"
    age_private_key     = "some-private-key"
    age_public_key      = "some-public-key"
}
