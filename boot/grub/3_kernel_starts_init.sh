function main() {
  _start_init_as_first_user_space_process
}

# Implementation of Init:
# sys-five:/etc/inittab (System-V)
# upstart: /etc/init (old debian)
# systemd:/etc/systemd (inspired from darwin launchd - goal oriented)
# runit (android)
function _start_init_as_first_user_space_process() {
        cd ../user
        sh  1_systemd.sh
}