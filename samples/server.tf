resource "sakura_server" "fail_server_1" {
  name   = "fail-server-1"
  disks  = [sakura_disk.fail_disk_1.id]
  core   = 1
  memory = 1

  disk_edit_parameter = {
    hostname        = "fail-server-1"
    disable_pw_auth = false
    password        = var.password
  }
}

resource "sakura_server" "pass_server_1" {
  name   = "pass-server-1"
  disks  = [sakura_disk.pass_disk_1.id]
  core   = 1
  memory = 1

  disk_edit_parameter = {
    hostname        = "pass-server-1"
    disable_pw_auth = true
    ssh_key_ids     = [sakura_ssh_key.user_key.id]
  }
}
