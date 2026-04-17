data "sakura_archive" "ubuntu2204" {
  os_type = "ubuntu2204"
}

resource "sakura_disk" "fail_disk_1" {
  name                 = "fail_disk_1"
  size                 = 20
  plan                 = "ssd"
  connector            = "virtio"
  source_archive_id    = data.sakura_archive.ubuntu2204.id
  encryption_algorithm = "none"
  # prevent re-creation of the disk when archive id is changed
  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakura_disk" "pass_disk_1" {
  name                 = "pass_disk_1"
  size                 = 40
  plan                 = "ssd"
  connector            = "virtio"
  source_archive_id    = data.sakura_archive.ubuntu2204.id
  encryption_algorithm = "aes256_xts"
  # prevent re-creation of the disk when archive id is changed
  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}
