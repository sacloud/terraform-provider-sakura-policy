package main

import data.test.helpers.no_violations
import rego.v1

test_not_specified_allowed_networks if {
  cfg := parse_config("hcl2", `
resource "sakura_enhanced_db" "test" {
  name     = "test"
  password_wo         = "password-123456789"
  password_wo_version = 1

  database_name = "testdb"
  database_type = "tidb"
  region        = "is1"
}`)

  violation_sakura_enhanced_db_unrestricted_source_networks[{
    "msg": "sakura_enhanced_db_unrestricted_source_networks\nSource network is not restricted for sakura_enhanced_db.test connection\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_enhanced_db/unrestricted_source_networks/\n",
    "resource": "sakura_enhanced_db",
    "rule": "sakura_enhanced_db_unrestricted_source_networks",
	}] with input as cfg
}

test_specified_allowed_networks if {
	cfg := parse_config("hcl2", `
resource "sakura_enhanced_db" "test" {
  name     = "test"
  password_wo         = "password-123456789"
  password_wo_version = 1

  database_name = "testdb"
  database_type = "tidb"
  region        = "is1"

  allowed_networks = [
    "192.0.2.0/24"
  ]
}`)

	no_violations(violation_sakura_enhanced_db_unrestricted_source_networks) with input as cfg
}
