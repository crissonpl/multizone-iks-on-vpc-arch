##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.ibm_region
  generation            = var.generation
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Resource Group where VPC will be created
##############################################################################

data ibm_resource_group resource_group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# VPC Module
##############################################################################

module vpc {
    source                = "./multizone_vpc"
    unique_id             = var.unique_id
    ibm_region            = var.ibm_region
    resource_group_id     = data.ibm_resource_group.resource_group.id
    acl_rules             = var.acl_rules
    enable_public_gateway = var.enable_public_gateway
    cidr_blocks           = var.cidr_blocks
}

##############################################################################


##############################################################################
# Cluster
##############################################################################

module cluster {
    source              = "./vpc_cluster"
    ibm_region          = var.ibm_region
    resource_group_id   = data.ibm_resource_group.resource_group.id
    vpc_id              = module.vpc.vpc_id
    subnet_ids          = module.vpc.subnet_ids
    cluster_name        = "${var.unique_id}-cluster"
    machine_type        = var.machine_type
    workers_per_zone    = var.workers_per_zone
    kube_version        = var.kube_version
    wait_till           = var.wait_till
    worker_pools        = var.worker_pools
}

##############################################################################