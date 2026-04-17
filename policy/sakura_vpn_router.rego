package main

import data.exception
import data.helpers.has_field
import data.test.helpers.no_violations
import rego.v1

violation_sakura_vpn_router_internet_connection_without_firewall contains decision if {
	resource := "sakura_vpn_router"
	rule := "sakura_vpn_router_internet_connection_without_firewall"

	some name
	vpn_router := input.resource[resource][name][_]

	is_internet_connected(vpn_router)
	not used_firewall_global_interface(vpn_router)

	url := "https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_vpc_router/internet_connection_without_firewall/"
	decision := {
		"msg": sprintf(
			"%s\nInternet connection is enabled on %s.%s, but no firewall is configured on the global interface\nMore Info: %s\n",
			[rule, resource, name, url],
		),
		"resource": resource,
		"rule": rule,
	}
}

is_internet_connected(vpn_router) if {
	not has_field(vpn_router, "internet_connection")
}

is_internet_connected(vpn_router) if {
	vpn_router.internet_connection == true
}

used_firewall_global_interface(vpn_router) if {
	vpn_router.firewall.interface_index == 0
}

used_firewall_global_interface(vpn_router) if {
	vpn_router.firewall[_].interface_index == 0
}

exception contains rules if {
	v := data.main.violation_sakura_vpn_router_internet_connection_without_firewall[_]

	input.resource[v.resource]
	exception.rule[_] == v.rule
	rules := [v.rule]
}

exception contains rules if {
	v := data.main.violation_sakura_vpn_router_internet_connection_without_firewall[_]

	some name
	input.resource[v.resource][name]
	name == exception.resource[v.resource][_]
	rules := [v.rule]
}

warn_sakura_vpn_router_unspecified_syslog_host contains decision if {
	resource := "sakura_vpn_router"
	rule := "sakura_vpn_router_unspecified_syslog_host"

	some name
	vpn_router := input.resource[resource][name][_]
	not has_field(vpn_router, "syslog_host")

	url := "https://docs.usacloud.jp/terraform-policy/rules/sakura_vpn_router/unspecified_syslog_host/"
	decision := {
		"msg": sprintf(
			"%s\nNo syslog server is configured for %s.%s\nMore Info: %s\n",
			[rule, resource, name, url],
		),
		"resource": resource,
		"rule": rule,
	}
}

exception contains rules if {
	v := data.main.warn_sakura_vpn_router_unspecified_syslog_host[_]

	input.resource[v.resource]
	exception.rule[_] == v.rule
	rules := [v.rule]
}