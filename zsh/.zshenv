# imports systemd environment to the regular shell
# thats some black magic. thanks bb010g!
# it even works with MANPAGER="nvim +Man!"
set -a
. /dev/fd/0 <<EOF
$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
EOF
set +a
