# dsr_lb in v3
resource "sakura_dsr_lb" "fail_lb_1" {
  name = "fail_lb_1"
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
    server = [
      {
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
      }
    ]
  }]
}

resource "sakura_dsr_lb" "pass_lb_1" {
  name = "pass_lb_1"
  plan = "standard"
  network_interface = {
    vswitch_id   = sakura_vswitch.pass_switch_1.id
    vrid         = 1
    ip_addresses = ["192.168.0.101"]
    netmask      = 24
    gateway      = "192.168.0.1"
  }
  vip = [{
    vip  = "192.168.0.201"
    port = 443
    server = [
      {
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
      }
    ]
  }]
}
