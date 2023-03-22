# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#

#============================================= PARAMS =============================================
# Nom de la première partition
name1="backup"
# Nom de la seconde partition
name2="data"


#============================================= SCRIPT =============================================
# Chargement du module
modprobe dm-mod

# Démarrage du démon lvm
/etc/init.d/lvm start

# Ajout du disque md1p2 (2nd partition du raid) a lvm
pvcreate /dev/md1p2

# Ajout du volume au groupe lvm vg1
vgcreate vg1 /dev/md1p2

# Creation de la 1ère partition
lvcreate -L500M -n$name1 vg1

# Creation du point de montage
mkdir /$name1

# Formatage et montage
mke2fs -t ext3 /dev/vg1/$name1
mount /dev/vg1/$name1 /$name1
sleep 1

# 2eme partition (idem 1ère)
lvcreate -L500M -n$name2 vg1

mkdir /$name2
mke2fs -t ext3 /dev/vg1/$name2
mount /dev/vg1/$name2 /$name2
sleep 1

# Ajout de lvm au démarrage (démon et module)
rc-update add lvm boot
echo "modprobe dm-mod" >> /etc/conf.d/modules

# Ajout des nouveau périphérique das /etc/fstab
echo -e  "\n/dev/vg1/$name1 /$name1 	ext3 	noatime 0 1\n" >> /etc/fstab
echo -e  "/dev/vg1/$name2 /$name2 	ext3 	noatime 0 1\n" >> /etc/fstab
