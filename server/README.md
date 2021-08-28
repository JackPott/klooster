# Initial net server bootstrap

- Start with distro piCore v13.0.3
- Burn to SD with [Etcher](etcher.io)
- Install on Raspberry Pi which will become the network server
- `filetool.sh -b`
- `sudo fdisk -u /dev/mmcblk0`
- ow list partitions with 'p' command and write down the starting and ending sectors of the second partition.
- Create new partition with 'n' starting at the same sector, end `+4G`
- `sudo reboot`
- `sudo resize2fs /dev/mmcblk0p2`
- Create fixed IP script /opt/eth0.sh
- `chmod 775 eth0.sh`
- `sudo echo ‘/opt/eth0.sh’ >> /opt/.filetool.lst`
- `sudo echo ‘/opt/eth0.sh &’ >> /opt/bootlocal.sh`
- `filetool.sh -b`
- `sudo /usr/local/etc/init.d/openssh start`
- `tce-load -wi python3.9`

- Create ansible user and password
- Static IP 254.254.254.1

- https://iotbytes.wordpress.com/configure-ssh-server-on-microcore-tiny-linux/

## Ansible

Create the default ssh user on netserver

```
docker run -it --rm --entrypoint /bin/sh -v /home/chrisaustin/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub:ro -v /home/chrisaustin/.ssh/id_rsa:/root/.ssh/id_rsa:ro -v (pwd):/ansible/playbooks ansible-control:0.0.1

```

ansible-playbook bootstrap.yml -i hosts.yml -k -K -vvvv --extra-vars "hosts=netserver user=tc pw=test123"
ansible-playbook bootstrap.yml -i hosts.yml -k -K -vvvv --extra-vars "hosts=netserver user=tc"

ansible-playbook bootstrap.yml -i hosts.yml -k -K -vvvv -u tc --extra-vars "hosts=netserver user=tc"

`ansible-playbook -i 10.254.254.1,10.254.254.1 --ask-pass site.yml`

Add ansible user to inventory
ansible-playbook site.yml -i -vvvv hosts.yml

## Extension

scp -r ansible@10.254.254.1:/tmp/matchbox/ . && scp -r ansible@10.254.254.1:/tmp/matchbox/ .
scp -r matchbox.tcz ansible@10.254.254.1:/tmp/

adduser -D matchbox
