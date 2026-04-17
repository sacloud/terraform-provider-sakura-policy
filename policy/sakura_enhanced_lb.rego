package main

import data.exception
import data.helpers.has_field
import rego.v1

violation_sakura_enhanced_lb_no_https_redirect contains decision if {
	resource := "sakura_enhanced_lb"
	rule := "sakura_enhanced_lb_no_https_redirect"

	some name
	enhanced_lb := input.resource[resource][name][_]
	not redirect_https(enhanced_lb)

	url := "https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_proxylb/no_https_redirect/"
	decision := {
		"msg": sprintf(
			"%s\nHTTP to HTTPS redirect is not enabled on %s.%s\nMore Info: %s\n",
			[rule, resource, name, url],
		),
		"resource": resource,
		"rule": rule,
	}
}

redirect_https(enhanced_lb) if {
	enhanced_lb.bind_port.proxy_mode == "http"
	enhanced_lb.bind_port.redirect_to_https == true
}

redirect_https(enhanced_lb) if {
	bind_port := enhanced_lb.bind_port[_]

	bind_port.proxy_mode == "http"
	bind_port.redirect_to_https == true
}

exception contains rules if {
	v := data.main.violation_sakura_enhanced_lb_no_https_redirect[_]

	input.resource[v.resource]
	exception.rule[_] == v.rule
	rules := [v.rule]
}

warn_sakura_enhanced_lb_unspecified_syslog_host contains decision if {
	resource := "sakura_enhanced_lb"
	rule := "sakura_enhanced_lb_unspecified_syslog_host"

	some name
	enhanced_lb := input.resource[resource][name][_]
	not has_field(enhanced_lb, "syslog")
	url := "https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_proxylb/unspecified_syslog_host/"

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
	v := data.main.warn_sakura_enhanced_lb_unspecified_syslog_host[_]

	input.resource[v.resource]
	exception.rule[_] == v.rule
	rules := [v.rule]
}
