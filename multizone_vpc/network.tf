
##############################################################################
# Create an  ACL for ingress/egress used by  all subnets in VPC
##############################################################################

resource ibm_is_network_acl multizone_acl {
      name = "${var.unique_id}-acl"
      vpc  = ibm_is_vpc.vpc.id
      dynamic rules {
            for_each = var.acl_rules
            content {
                  name        = rules.value.name
                  action      = rules.value.action
                  source      = rules.value.source
                  destination = rules.value.destination
                  direction   = rules.value.direction
            }
      }
}

##############################################################################


##############################################################################
# Change Default Security Group (Optional)
##############################################################################

resource ibm_is_security_group_rule allow_all_inbound {
      count     = var.default_sg_allow_inbound_traffic == true ? 1 : 0
      group     = ibm_is_vpc.vpc.default_security_group
      direction = "inbound"
      remote    = "0.0.0.0/0"
}

##############################################################################