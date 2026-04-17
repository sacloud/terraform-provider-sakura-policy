package main

import data.test.helpers.no_violations
import rego.v1

test_not_specified_encryption_algorithm if {
  cfg := parse_config("hcl2", `
resource "sakura_disk" "test" {
  name                 = "test"
  size                 = 20
  plan                 = "ssd"
  connector            = "virtio"
  source_archive_id    = data.sakura_archive.ubuntu2204.id
}`)
  violation_sakura_disk_not_encrypted[{
    "msg": "sakura_disk_not_encrypted\nDisk encryption is not enabled in sakura_disk.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_disk/not_encrypted/\n",
    "resource": "sakura_disk",
    "rule": "sakura_disk_not_encrypted",
	}] with input as cfg
}

test_specified_encryption_algorithm_none if {
  cfg := parse_config("hcl2", `
resource "sakura_disk" "test" {
  name                 = "test"
  size                 = 20
  plan                 = "ssd"
  connector            = "virtio"
  source_archive_id    = data.sakura_archive.ubuntu2204.id
  encryption_algorithm = "none"
}`)
  violation_sakura_disk_not_encrypted[{
    "msg": "sakura_disk_not_encrypted\nDisk encryption is not enabled in sakura_disk.test\nMore Info: https://docs.usacloud.jp/terraform-policy/rules/sakuracloud_disk/not_encrypted/\n",
    "resource": "sakura_disk",
    "rule": "sakura_disk_not_encrypted",
	}] with input as cfg
}

test_specified_encryption_algorithm_aes256_xts if {
	cfg := parse_config("hcl2", `
resource "sakura_disk" "test" {
  name                 = "test"
  size                 = 20
  plan                 = "ssd"
  connector            = "virtio"
  source_archive_id    = data.sakura_archive.ubuntu2204.id
  encryption_algorithm = "aes256_xts"
}`)
	no_violations(violation_sakura_disk_not_encrypted) with input as cfg
}
