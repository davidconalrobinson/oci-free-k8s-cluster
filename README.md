# oci-free-k8s-cluster

This terraform module deploys:
- An always-free kubernetes cluster on OCI (Oracle Cloud Infrastructure). The cluster consists of two nodes running [VM.Standard.A1.Flex](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#flexible) node shape - each with 2CPU, 12GB memory and 50GB boot volume. This falls within OCI's always-free quota for [compute](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#compute) and [block volume storage](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#blockvolume) (and leaves 100GB always-free block volume storage remaining for applications that may later be deployed on the cluster). The cluster is created in a dedicated compartment and VCN.
- A DNS zone for publicly exposing applications running on the cluster.
- [Argo CD](https://argo-cd.readthedocs.io/en/stable/) for managing the deployment of future applications on the cluster.
- Kubernetes secrets

## Pre-requisites

To use this module you will need to first [create and activate an OCI account](https://docs.oracle.com/en/cloud/paas/content-cloud/administer/create-and-activate-oracle-cloud-account1.html). Then follow the instructions [here](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-provider.htm#) to create your local `.oci/config` file. Make a note of the contents of this file - you will need it later to configure the terraform module.

In addition you will also need to install the following:
- [Terraform](https://www.terraform.io/) (replace `<version>` with the terraform version you would like to use)
    ```
    brew install tfenv
    tfenv install <version>
    tfenv use <version>
    ```
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
    ```
    brew install kubernetes-cli
    ```
- [oci-cli](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm)
    ```
    brew install oci-cli
    ```

## Using the module

The module can be used as follows (refer to [variables.tf](variables.tf) for variable descriptions):

```
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
    secrets             = [
        {
            namespace = "sops-secrets-operator"
            name      = "age-private-key-secret"
            data      = {
                age-private-key = "AGE-SECRET-KEY-0123456789"
            }
        }
    ]
}
```

## Notes on OCI's "always-free" offering

As of March 2025 OCI provides the following as part of their ["always-free" offering](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm):
>- All tenancies get the first 3,000 OCPU hours and 18,000 GB hours per month for free for VM instances using the VM.Standard.A1.Flex shape, which has an Arm processor. For Always Free tenancies, this is equivalent to 4 OCPUs and 24 GB of memory.
>- All tenancies receive a total of 200 GB of Block Volume storage, and five volume backups included in the Always Free resources. These amounts apply to both boot volumes and block volumes combined.
>- All Oracle Cloud Infrastructure tenancies created December 15, 2020 or later get one Always Free Flexible Load Balancer with a minimum and maximum bandwidth set to 10 Mbps.

Note that you should use OCI's always-free offering at your own risk. OCI could rescind/modify this offer at any time, and the offer is subject to some restrictions that you should be aware of (for example always-free block volume storage is only available in your home region).
