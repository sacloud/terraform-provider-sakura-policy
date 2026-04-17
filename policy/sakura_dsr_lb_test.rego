package main

import data.test.helpers.no_violations
import rego.v1

test_enable_http_port if {
	cfg := parse_config("hcl2", `
resource "sakura_dsr_lb" "test" {
  name = "test"
  plan = "standard"
  network_interface = {
    vswitch_id   = sakura_vswitch.fail_switch_1.id
    vrid         = 1
    ip_addresses = ["192.168.0.101"]
    netmask      = 24
    gateway      = "192.168.0.1"
  }
  vip = [{
    vip  = "192.168.0.201"
    port = 80

    server = [{
      ip_address = "192.168.0.51"
      protocol   = "http"
      path       = "/health"
      status     = 200
    },
    {
      ip_address = "192.168.0.52"
      protocol   = "http"
      path       = "/health"
      status     = 200
    }]
  }]
}`)
	violation_sakura_dsr_lb_http_not_enabled[{
		"msg": "sakura_dsr_lb_http_not_enabled\nPort 80 is open on the VIP address of sakura_dsr_lb.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_load_balancer/http_not_enabled/\n",
		"resource": "sakura_dsr_lb",
		"rule": "sakura_dsr_lb_http_not_enabled",
	}] with input as cfg
}

test_enable_https_port if {
	cfg := parse_config("hcl2", `
resource "sakura_dsr_lb" "test" {
  name = "test"
  plan = "standard"
  network_interface = {
    vswitch_id   = sakura_vswitch.test.id
    vrid         = 1
    ip_addresses = ["192.168.0.101"]
    netmask      = 24
    gateway      = "192.168.0.1"
  }
  vip = [{
    vip  = "192.168.0.201"
    port = 443

    server = [{
      ip_address = "192.168.0.51"
      protocol   = "https"
      path       = "/health"
      status     = 200
    },
    {
      ip_address = "192.168.0.52"
      protocol   = "https"
      path       = "/health"
      status     = 200
    }]
  }]
}`)
	no_violations(violation_sakura_dsr_lb_http_not_enabled) with input as cfg
}

test_not_specified_vip if {
	cfg := parse_config("hcl2", `
resource "sakura_dsr_lb" "test" {
  name = "test"
  plan = "standard"
  network_interface = {
    vswitch_id   = sakura_vswitch.fail_switch_1.id
    vrid         = 1
    ip_addresses = ["192.168.0.101"]
    netmask      = 24
    gateway      = "192.168.0.1"
  }
}`)
	no_violations(violation_sakura_dsr_lb_http_not_enabled) with input as cfg
}
