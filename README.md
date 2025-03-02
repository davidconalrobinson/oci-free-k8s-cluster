# oci-free-k8s-cluster

This terraform module deploys an always-free kubernetes cluster on OCI (Oracle Cloud Infrastructure). The cluster consists of two nodes running [VM.Standard.A1.Flex](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#flexible) node shape - each with 2CPU, 12GB memory and 50GB boot volume. This falls within OCI's always-free quota for [compute](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#compute) and [block volume storage](https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#blockvolume) (and leaves 100GB always-free block volume remaining for applications that may later be deployed on the cluster.).

This module also installs [Argo CD](https://argo-cd.readthedocs.io/en/stable/) for managing the deployment of future applications on the cluster.

# Pre-requisites

To use this module you will first need to install:
- Terraform
    ```
    brew install tfenv
    tfenv xxx
    ```
- kubectl
    ```
    brew install kubernetes-cli
    ```
- oci
    ```
    xxx
    ```

In addition you will also need to obtain the following for authenticating to your OCI account (refer here):
- xxx

# Using the module

The module can be used as follows (refer to variables.tf for variable descriptions):

```
module "oci_free_k8s_cluster {
    source = "xxx"

    tenancy_ocid        = "ocid1.tenancy.oc1..thisisafaketenancyocid"
    fingerprint         = "th:is:is:af:ak:ef:in:ge:rp:ri:nt"
    user_ocid           = "ocid1.user.oc1..thisisafakeuserocid"
    private_key_path    = "/path/to/oci/private-key.pem"
    region              = "eu-amsterdam-1"
    dns_name            = "example.com"
    availability_domain = "chxt:eu-amsterdam-1-AD-1"
    node_image_id       = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaafzh7gzsjes6na6rebvxtgs7ldp5qcjegal5y76ouhut4prih4y5q"
}
```
