# variables
dom0:="xen.blue-edmontosaurus.ts.net"
user:="operateur"
vg:="nvme_vg"
branch:="main"

create_disk machine size:
  ssh {{user}}@{{dom0}} "sudo lvcreate --name {{machine}} --size {{size}} {{vg}}"
  ssh {{user}}@{{dom0}} "sudo mkfs.btrfs /dev/{{vg}}/{{machine}}"

prepare_disk machine:
  ssh {{user}}@{{dom0}} "sudo mkdir -p /mnt"
  ssh {{user}}@{{dom0}} "sudo mount -t btrfs /dev/{{vg}}/{{machine}} /mnt"
  ssh {{user}}@{{dom0}} "sudo btrfs subvolume create /mnt/boot; \
    sudo btrfs subvolume create /mnt/nix; \
    sudo btrfs subvolume create /mnt/persistent"

send_config:
  ssh {{user}}@{{dom0}} -t "git init --bare homelab.git"
  git push ssh://{{user}}@{{dom0}}/home/{{user}}/homelab.git {{branch}}
  ssh {{user}}@{{dom0}} "cd homelab.git; git worktree add {{branch}}"

