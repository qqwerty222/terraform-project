module "security_groups" {
    source = "../../modules/security_groups"

    vpc_id = data.consul_keys.network.var.vpc_id

    security_groups = [
        jsondecode(data.consul_keys.security_groups.var.ssh_from_internet),
        jsondecode(data.consul_keys.security_groups.var.ping)
    ]
}

data "consul_keys" "network" {
    key { 
        name = "vpc_id" 
        path = "${var.PROJECT_NAME}/network/vpc/id"
    }
}

data "consul_keys" "security_groups" {
    key {
        name = "ssh_from_internet"
        path = "${var.PROJECT_NAME}/security_groups/ssh_from_internet/json"
    }
    
    key {
        name = "ping"
        path = "${var.PROJECT_NAME}/security_groups/ping/json"
    }
}

module "consul_push" {
    source = "../../modules/consul_kv"

    push_lists = [
        { path = "dns-deploy/security_groups/ids", value = module.security_groups.ids_json},
    ]
}
