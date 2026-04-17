terraform {
  required_providers {
    sakura = {
      source  = "sacloud/sakura"
      version = "~> 3"
    }
  }
}

provider "sakura" {
  zone         = "is1b"
  default_zone = "is1b"
}
