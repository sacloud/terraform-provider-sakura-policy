resource "sakura_enhanced_db" "fail_enhanced_db_1" {
  name        = "fail_enhanced_db_1"
  password_wo = var.password

  database_name = "faildb1"
  database_type = "tidb"
  region        = "is1"
}

resource "sakura_enhanced_db" "pass_enhanced_db_1" {
  name        = "pass_enhanced_db_1"
  password_wo = var.password

  database_name = "passdb1"
  database_type = "tidb"
  region        = "is1"

  allowed_networks = [
    "192.168.0.0/24"
  ]
}
