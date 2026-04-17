package main

import data.exception
import rego.v1

violation_sakura_dsr_lb_http_not_enabled contains decision if {
	resource := "sakura_dsr_lb"
	rule := "sakura_dsr_lb_http_not_enabled"

	some name
	dsr_lb := input.resource[resource][name][_]
	dsr_lb.vip[_].port == 80

	url := "https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_load_balancer/http_not_enabled/"
	decision := {
		"msg": sprintf(
			"%s\nPort 80 is open on the VIP address of %s.%s\nMore Info: %s\n",
			[rule, resource, name, url],
		),
		"resource": resource,
		"rule": rule,
	}
}

exception contains rules if {
	v := data.main.violation_sakura_dsr_lb_http_not_enabled[_]

	input.resource[v.resource]
	exception.rule[_] == v.rule
	rules := [v.rule]
}