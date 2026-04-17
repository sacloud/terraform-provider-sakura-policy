# vpn_router in v3
resource "sakura_vpn_router" "fail_vpc_1" {
  name                = "fail_vpc_1"
  internet_connection = true
}

resource "sakura_vpn_router" "pass_vpc_1" {
  name                = "pass_vpc_1"
  internet_connection = true
  syslog_host         = "192.168.0.1"
  firewall = [{
    interface_index = 0
    direction       = "receive"
    expression = [
      {
        protocol            = "tcp"
        source_network      = ""
        source_port         = "443"
        destination_network = ""
        destination_port    = ""
        allow               = true
        logging             = true
        description         = "desc"
      },
      {
        protocol            = "ip"
        source_network      = ""
        source_port         = ""
        destination_network = ""
        destination_port    = ""
        allow               = false
        logging             = true
        description         = "desc"
      }
    ]
  }]
}
