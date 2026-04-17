package main

import data.test.helpers.no_violations
import rego.v1

test_not_specified_redirect_to_https if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol    = "http"
    delay_loop  = 10
    host_header = "example.com"
    path        = "/"
  }

  bind_port = [{
    proxy_mode = "http"
    port       = 80
  }]
}`)
	violation_sakura_enhanced_lb_no_https_redirect[{
		"msg": "sakura_enhanced_lb_no_https_redirect\nHTTP to HTTPS redirect is not enabled on sakura_enhanced_lb.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_proxylb/no_https_redirect/\n",
		"resource": "sakura_enhanced_lb",
		"rule": "sakura_enhanced_lb_no_https_redirect",
	}] with input as cfg
}

test_disable_redirect_to_https if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol    = "http"
    delay_loop  = 10
    host_header = "example.com"
    path        = "/"
  }

  bind_port = [{
    proxy_mode        = "http"
    port              = 80
    redirect_to_https = false
  }]
}`)
	violation_sakura_enhanced_lb_no_https_redirect[{
		"msg": "sakura_enhanced_lb_no_https_redirect\nHTTP to HTTPS redirect is not enabled on sakura_enhanced_lb.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_proxylb/no_https_redirect/\n",
		"resource": "sakura_enhanced_lb",
		"rule": "sakura_enhanced_lb_no_https_redirect",
	}] with input as cfg
}

test_redirect_to_https if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol   = "http"
    delay_loop = 10
    path       = "/"
  }

  bind_port = [{
    proxy_mode        = "http"
    port              = 80
    redirect_to_https = true
  },
  {
    proxy_mode = "https"
    port       = 443
  }]
}`)
	no_violations(violation_sakura_enhanced_lb_no_https_redirect) with input as cfg
}

test_redirect_to_https_not_specified_https_bind_port if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol   = "http"
    delay_loop = 10
    path       = "/"
  }

  bind_port = [{
    proxy_mode        = "http"
    port              = 80
    redirect_to_https = true
  }]
}`)
	no_violations(violation_sakura_enhanced_lb_no_https_redirect) with input as cfg
}

test_unspecified_syslog_host if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol   = "http"
    delay_loop = 10
    path       = "/"
  }

  bind_port = [{
    proxy_mode = "http"
    port       = 80
  }]
}`)
	warn_sakura_enhanced_lb_unspecified_syslog_host[{
		"msg": "sakura_enhanced_lb_unspecified_syslog_host\nNo syslog server is configured for sakura_enhanced_lb.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_proxylb/unspecified_syslog_host/\n",
		"resource": "sakura_enhanced_lb",
		"rule": "sakura_enhanced_lb_unspecified_syslog_host",
	}] with input as cfg
}

test_specified_syslog_host if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_lb" "test" {
  name = "test"
  plan = 100

  health_check = {
    protocol   = "http"
    delay_loop = 10
    path       = "/"
  }

  bind_port = [{
    proxy_mode = "http"
    port       = 80
  }]

  syslog = {
    server = "192.0.2.1"
    port   = 514
  }
}`)
	no_violations(warn_sakura_enhanced_lb_unspecified_syslog_host) with input as cfg
}
