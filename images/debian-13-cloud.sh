#/bin/bash

wget https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2

cp debian-13-genericcloud-amd64.qcow2 debian-13-genericcloud-amd64-custom.qcow2

virt-customize -a debian-13-genericcloud-amd64-custom.qcow2 \
    --install qemu-guest-agent,gnupg,git \
    --run-command 'systemctl enable qemu-guest-agent'
