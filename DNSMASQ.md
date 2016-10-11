dnsmasq example configuration
==

DNSmasq is using the local hosts file for name resolution, make sure the machines are known.
```
root@pris:~# cat /etc/hosts
127.0.0.1       localhost.localdomain localhost

192.168.6.4     pris.rorschach.benningen.midokura.de pris

192.168.9.11    mx001.borg.benningen.midokura.de mx001

192.168.9.13    mx003.borg.benningen.midokura.de mx003

192.168.9.15    mx005.borg.benningen.midokura.de mx005
192.168.9.16    mx006.borg.benningen.midokura.de mx006
192.168.9.17    mx007.borg.benningen.midokura.de mx007

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

This is a very simple dnsmasq configuration.
```
root@pris:~# cat /etc/dnsmasq.conf
domain=borg.benningen.midokura.de
interface=enp5s0
dhcp-range=192.168.9.100,192.168.9.200,12h
dhcp-option=3,192.168.9.1
dhcp-boot=pxelinux/pxelinux.0
enable-tftp
tftp-root=/var/lib/tftpboot

# ost-controller
dhcp-host=50:e5:49:41:b7:f6,192.168.9.11,mx001
dhcp-host=68:05:ca:24:6d:21,192.168.9.12,mx001

# k8s-controller
dhcp-host=00:04:4b:14:ae:6d,192.168.9.13,mx003
dhcp-host=00:04:4b:14:ae:6b,192.168.9.14,mx003

# k8s-workers
dhcp-host=d0:50:99:95:ef:b3,192.168.9.15,mx005
dhcp-host=d0:50:99:99:e6:4c,192.168.9.16,mx006
dhcp-host=44:8a:5b:ef:e2:06,192.168.9.17,mx007
```

This is a general cloud config for all the machines. If you want a cloud-config per machine you will have to create files in /var/lib/tftpboot/pxelinux/pxelinux.cfg/01-xx-xx-xx-yy-yy-yy where xx-xx-xx-yy-yy-yy is the mac address of the box. These files then can point to a different URL. Also the webserver does not have to be in your LAN, it can be anywhere.
```
root@pris:~# cat /var/www/html/cloud-config.yml
#cloud-config
coreos:
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQCzeqTu49jnisBmDLKcZs+FxNro4vovXr294jqWFadEXCuyCE3F/MWV80prrag1Q4trM/L4ki9XLh/EzCyfDQGbTuhZsn+7Uk78qghxS8WnAtyrKas6IZD44bJARPLXo/YpIHU3sM8umCHoe+TfTjnVtQRfBn6S8elYEwRtbT28mE+gNuz/wq9JjHhLicsZbp8dPJmPefmCZf4ueOsDEGIrBhgyUuaTqYMiLPIJBbOwB18bUtHNxTXYl3xGA4O0tHiz+279DWEYc1mJAUQMTqHTEEY9CEIvZrQRr677pVIYJPnYfaSUMzT2TMeBHYWI7aFALghbMxOHEpUsK4OtPnU+Qslzba2YOf1HhzWYq4vZ1ydQGXsrwOPhoRKoEaFbGha+a2iAM4P1+pI0jHL2R583SStNZLpdqwRq0J+86AxOq1TMvdNgiMVGn2LZDLJGsbgspWX/RRdoraY0EOcHTx2QEpDWF0UHPTF7F+khxBItOuRc+3wcQ09EbDmAaZFCg0tFFJaISr4yObXuP98L3m0bVbje5jevl1NrfPGarvNsSBSKmDN9MEbEXkL5rlt/ypnS6kkKa6Q8Sc/qVAsN/b7hRZo/6DRTDS9ZRWqbREkGATtvYyezR+yohI+5tig/emAoE1JRn3RzDq/O4mikQSZoVZfR0XDTFJmmwg6yVBCjcbZTqVgKzqkMw44lcC4Y06xwCEl0JzygNvOnlApuwaPcYZStMO/v55ymqv3putQc1ju0LXT64x/NuCZ3qpb7PMeWwBV0CVptFioYpzuzs+xwg6noCZNYpblZORKpveWaZ5Wz0UfvL/Sn6U+nMdTn23ybgQqSStvboMoJ/hLkLSHUmtFlmkLEIb5vWiGBF9jNMcuJmKY7eTHOJc98wICjfdUJpbMRKfNk45ym1S6U9UQ0eGCHTy4/Hnlo1oEs/DfuxaqEg75ELTRX/RO1Ty3FVX4qlHcXpuEEokUv+LCQQTvnjS2fK/xPyp4bhwi9WEALub/bn7eHfTnUNKPxrZrEpzsl+Dx26o1WsRmZo1nTiLdjyv92mQUSoKzc7LcaSf4K8yO94+NpjernYWHPzj3GITVsbESeXKR8BSCORdGagQhXWmdmFiDQ7uFkyz0nu02PY4DTwrsxEz06g2krSS0ahKZV4EO2VgzG0MY59RUeNFyZaCyEBYIC60+iBWIUosRpmoffw00eJZujoPf5+G2vyQLJ5ierP8D/2gjFNQE8OZY6YtH6nO69lP9D1w0JRLMYpk27BXWpO+EvDt/VYY4lKw+xJhJXLPYGLZmZLfL2kPUXhyn2Pn9yG78l1TkefEKe4cmwhLqkgdE5s2FRISFIoYPbakOUY2Bg3XbB/nFqANvZ agabert@starfish
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7X914jmXE05E6q1HfPLMGE/8Ua1TwPu0jtbmXEd2J/TveoXc3/JgqPwqY0n95RI2yI4darJcrH0jNukxJYlSb1XRGgUPTF2Uv3+IQEAwYvvCgZ/8iI10j/dpqpFqLIwN5tTFbrJpcSqrGMyd4KS2syGPn6JGThKuBXM+SXTR45sSPGwhdtHGbWRIAnop6AZVIBw18PyXta4rk5Cfp/0fOYxdeBdA0qsq7Pee2bL/1WLqmGqb0HUoJkYSxBuiPfZd0YwR2DQFy1vIFTssmF/hwr35hvFDM3z0qSJr75vw2c3vQDhB3epMPrtwVJEVRUJ1SLqBQJ2a4kjm8n0G/3/oz agabert@Alexanders-MBP
```

Make sure the tftpboot directory looks like this with all files accessible, you can easily get the coreos_production images from their website.
```
root@pris:/var/lib/tftpboot/pxelinux# tree
.
├── coreos_production_pxe_image.cpio.gz
├── coreos_production_pxe.vmlinuz
├── ldlinux.c32 -> /usr/lib/syslinux/modules/bios/ldlinux.c32
├── pxelinux.0 -> /usr/lib/PXELINUX/pxelinux.0
└── pxelinux.cfg
    └── default

1 directory, 5 files
```

Remember that you need the package *pxelinux*, otherwise you will not be able to find /usr/lib/PXELINUX/pxelinux.0 on your machine.
Also tftpd-hpa is maybe unneeded, it is possible that it is a remnantfrom earlier testing without dnsmasq.
```
root@pris:/var/lib/tftpboot/pxelinux# dpkg -l | egrep 'dnsmasq|tftp|pxe'
ii  dnsmasq                            2.75-1ubuntu0.16.04.1             all          Small caching DNS proxy and DHCP/TFTP server
ii  dnsmasq-base                       2.75-1ubuntu0.16.04.1             amd64        Small caching DNS proxy and DHCP/TFTP server
ii  pxelinux                           3:6.03+dfsg-11ubuntu1             all          collection of bootloaders (PXE network bootloader)
ii  tftp                               0.17-18ubuntu2                    amd64        Trivial file transfer protocol client
rc  tftpd                              0.17-18ubuntu2                    amd64        Trivial file transfer protocol server
ii  tftpd-hpa                          5.2+20150808-1ubuntu1             amd64        HPA's tftp server
```

This is the configuration file for PXELINUX that will let the machines boot coreos over the network.
Note that when the machines have multiple NICs all of them get an IP.
```
root@pris:/var/lib/tftpboot/pxelinux# cat pxelinux.cfg/default
default coreos
prompt 1
timeout 15

display boot.msg

label coreos
  menu default
  kernel coreos_production_pxe.vmlinuz
  append initrd=coreos_production_pxe_image.cpio.gz cloud-config-url=http://192.168.9.1/cloud-config.yml coreos.autologin console=tty0
```

