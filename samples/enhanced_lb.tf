# enhanced_lb in v3
resource "sakura_enhanced_lb" "fail_proxylb_1" {
  name = "fail_proxylb_1"
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
}

resource "sakura_enhanced_lb" "pass_proxylb_1" {
  name = "pass_proxylb_1"
  plan = 100

  health_check = {
    protocol   = "http"
    delay_loop = 10
    path       = "/"
  }

  bind_port = [
    {
      proxy_mode        = "http"
      port              = 80
      redirect_to_https = true
    },
    {
      proxy_mode = "https"
      port       = 443
    }
  ]

  syslog = {
    server = "163.43.179.80"
    port   = 514
  }
}
