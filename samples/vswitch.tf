# vswitch in v3
# used by fail_lb_1
resource "sakura_vswitch" "fail_switch_1" {
  name = "fail_switch_1"
}

# used by pass_lb_1
resource "sakura_vswitch" "pass_switch_1" {
  name = "pass_switch_1"
}
