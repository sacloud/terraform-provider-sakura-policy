package main

import data.test.helpers.no_violations
import rego.v1

test_enable_pw_auth_with_password if {
	cfg := parse_config("hcl2", `
resource "sakura_server" "test" {
  name   = "test"
  disks  = [sakura_disk.test.id]
  core   = 1
  memory = 1

  disk_edit_parameter = {
    hostname           = "test"
    disable_pw_auth    = false
    password_wo        = "password-123456789"
    password_wo_version = 1
  }
}`)

	violation_sakura_server_pw_auth_enabled_with_password[{
		"msg": "sakura_server_pw_auth_enabled_with_password\nPassword authentication is enabled with a password set on sakura_server.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_server/pw_auth_enabled_with_password/\n",
		"resource": "sakura_server",
		"rule": "sakura_server_pw_auth_enabled_with_password",
	}] with input as cfg
}

test_disable_pw_auth_with_ssh_key_ids if {
	cfg := parse_config("hcl2", `
resource "sakura_server" "test" {
  name   = "test"
  disks  = [sakura_disk.test.id]
  core   = 1
  memory = 1

  disk_edit_parameter = {
    hostname        = "test"
    disable_pw_auth = true

    ssh_key_ids = [resource.sakura_ssh_key.user_key.id]
  }
}`)

	no_violations(violation_sakura_server_pw_auth_enabled_with_password) with input as cfg
}

test_disable_pw_auth_with_password_and_ssh_key_ids if {
	cfg := parse_config("hcl2", `
resource "sakura_server" "test" {
  name   = "test"
  disks  = [sakura_disk.test.id]
  core   = 1
  memory = 1

  disk_edit_parameter = {
    hostname           = "test"
    disable_pw_auth    = true

    password_wo        = "password-123456789"
    password_wo_version = 1
    ssh_key_ids        = [resource.sakura_ssh_key.user_key.id]
  }
}`)

	no_violations(violation_sakura_server_pw_auth_enabled_with_password) with input as cfg
}

test_not_specified_disk_edit_parameter if {
	cfg := parse_config("hcl2", `
resource "sakura_server" "test" {
  name   = "test"
  disks  = [sakura_disk.test.id]
  core   = 1
  memory = 1
}`)

	no_violations(violation_sakura_server_pw_auth_enabled_with_password) with input as cfg
}
