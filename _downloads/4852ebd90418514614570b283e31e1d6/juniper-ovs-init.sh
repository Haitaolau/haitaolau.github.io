echo 8 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
echo 1048 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

sleep 10 

mkdir /dev/huge1G
mkdir /dev/huge2M

mount -t hugetlbfs -o pagesize=1G none /dev/huge1G
mount -t hugetlbfs -o pagesize=2M none /dev/huge2M
chmod a+w /dev/huge1G -R
chmod a+w /dev/huge2M -R

modprobe kvm
modprobe kvm-intel
modprobe igb_uio
modprobe vfio-pci

chmod a+x /dev/vfio

chmod 0666 /dev/vfio/*


ip link set eth0 up 
ip link set eth0 promisc on 
ip link set eth0 allmulticast on 
ip link set eth0 mtu 9216 
ip link set eth1 up 
ip link set eth1 promisc on 
ip link set eth1 allmulticast on 
ip link set eth1 mtu 9216 
echo 16 > /sys/class/net/eth0/device/sriov_numvfs
sleep 10

echo 16 > /sys/class/net/eth1/device/sriov_numvfs
sleep 10
ip link set dev eth0 vf 0 trust off 
ip link set dev eth0 vf 0 spoofchk on 
ip link set dev eth0 vf 1 trust off 
ip link set dev eth0 vf 1 spoofchk on 
ip link set dev eth0 vf 2 trust off 
ip link set dev eth0 vf 2 spoofchk on 
ip link set dev eth0 vf 3 trust off 
ip link set dev eth0 vf 3 spoofchk on 
ip link set dev eth0 vf 4 trust off 
ip link set dev eth0 vf 4 spoofchk on 
ip link set dev eth0 vf 5 trust off 
ip link set dev eth0 vf 5 spoofchk on 
ip link set dev eth0 vf 6 trust off 
ip link set dev eth0 vf 6 spoofchk on 
ip link set dev eth0 vf 7 trust off 
ip link set dev eth0 vf 7 spoofchk on 
ip link set dev eth0 vf 8 trust off 
ip link set dev eth0 vf 8 spoofchk on 
ip link set dev eth0 vf 9 trust off 
ip link set dev eth0 vf 9 spoofchk on 
ip link set dev eth0 vf 10 trust off 
ip link set dev eth0 vf 10 spoofchk on 
ip link set dev eth0 vf 11 trust off 
ip link set dev eth0 vf 11 spoofchk on 
ip link set dev eth0 vf 12 trust off 
ip link set dev eth0 vf 12 spoofchk on 
ip link set dev eth0 vf 13 trust off 
ip link set dev eth0 vf 13 spoofchk on 
ip link set dev eth0 vf 14 trust off 
ip link set dev eth0 vf 14 spoofchk on 
ip link set dev eth0 vf 15 trust off 
ip link set dev eth0 vf 15 spoofchk on 
ip link set dev eth1 vf 0 trust off 
ip link set dev eth1 vf 0 spoofchk off
ip link set dev eth1 vf 1 trust off 
ip link set dev eth1 vf 1 spoofchk off 
ip link set dev eth1 vf 2 trust off 
ip link set dev eth1 vf 2 spoofchk off 
ip link set dev eth1 vf 3 trust off 
ip link set dev eth1 vf 3 spoofchk off 
ip link set dev eth1 vf 4 trust off 
ip link set dev eth1 vf 4 spoofchk off 
ip link set dev eth1 vf 5 trust off 
ip link set dev eth1 vf 5 spoofchk off 
ip link set dev eth1 vf 6 trust off 
ip link set dev eth1 vf 6 spoofchk off 
ip link set dev eth1 vf 7 trust off 
ip link set dev eth1 vf 7 spoofchk off 
ip link set dev eth1 vf 8 trust off 
ip link set dev eth1 vf 8 spoofchk off 
ip link set dev eth1 vf 9 trust off 
ip link set dev eth1 vf 9 spoofchk off 
ip link set dev eth1 vf 10 trust off 
ip link set dev eth1 vf 10 spoofchk off 
ip link set dev eth1 vf 11 trust off 
ip link set dev eth1 vf 11 spoofchk off 
ip link set dev eth1 vf 12 trust off 
ip link set dev eth1 vf 12 spoofchk off 
ip link set dev eth1 vf 13 trust off 
ip link set dev eth1 vf 13 spoofchk off 
ip link set dev eth1 vf 14 trust off 
ip link set dev eth1 vf 14 spoofchk off 
ip link set dev eth1 vf 15 trust off 
ip link set dev eth1 vf 15 spoofchk off 

ovs-vsctl --if-exists del-br ovs-sys-br
ovs-vsctl --no-wait init
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=0x1 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem=1088 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-limit=1088 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true 
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x40 
ovs-vsctl add-br ovs-sys-br -- set Bridge ovs-sys-br datapath_type=netdev 
ovs-vsctl set port ovs-sys-br trunks=1, 
#ip link set eth0 down 
ip link set eth0 vf 15 mac 30:7c:5e:4c:a8:4a allmulticast on 
#ip link set eth0 up 
/usr/share/dpdk/usertools/dpdk-devbind.py -u 0000:03:13.6 
/usr/share/dpdk/usertools/dpdk-devbind.py --bind=igb_uio 0000:03:13.6 
ovs-vsctl add-port ovs-sys-br dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:03:13.6 mtu_request=2048 
ovs-vsctl set port dpdk0 tag=4095 
ip link set eth1 down 
ip link set eth1 vf 15 mac 30:7c:5e:4c:a8:4b allmulticast on 
ip link set eth1 up 
/usr/share/dpdk/usertools/dpdk-devbind.py -u 0000:03:13.7 
/usr/share/dpdk/usertools/dpdk-devbind.py --bind=igb_uio 0000:03:13.7 
ovs-vsctl add-port ovs-sys-br dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:03:13.7 mtu_request=2048 
ovs-vsctl set port dpdk1 tag=4095 

ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth0 -- set Interface centos1_eth0 type=dpdkvhostuser mtu_request=1500
ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth1 -- set Interface centos1_eth1 type=dpdkvhostuser mtu_request=1500
ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth2 -- set Interface centos1_eth2 type=dpdkvhostuser mtu_request=1500
ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth3 -- set Interface centos1_eth3 type=dpdkvhostuser mtu_request=1500
ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth4 -- set Interface centos1_eth4 type=dpdkvhostuser mtu_request=1500
ovs-vsctl --may-exist add-port ovs-sys-br centos1_eth5 -- set Interface centos1_eth5 type=dpdkvhostuser mtu_request=1500
