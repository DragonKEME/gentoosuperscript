# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#

#============================================= PARAMS =============================================
# Nom du disque dur dans /dev
dev="sda"

#============================================= SCRIPT =============================================
# Chargement du module
modprobe raid1

# Creation du node (pas obligatoire)
#mknod /dev/md1 b 9 1

# Creation du raid a partir des 2 dernière partitions du disque
mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/${dev}5 /dev/${dev}6 <<< "yes"

# Chargement du fichier de configuration pour garder les raid au démarrage
echo "DEVICE        /dev/${dev}5" >> /etc/mdadm.conf
echo "DEVICE        /dev/${dev}6" >> /etc/mdadm.conf
echo "ARRAY         /dev/md1 devices=/dev/${dev}5,/dev/${dev}6" >> /etc/mdadm.conf
echo "MAILADDR      root@localhost" >> /etc/mdadm.conf

# Creation des partions demandée
fdisk /dev/md1 < fdisk.md1.comand
mke2fs -t ext3 /dev/md1p1

# Montage de la partition
mount /dev/md1p1 /mnt/backup
sleep 1

# Chargement du module au demarrage
echo "modprobe raid1" >> /etc/conf.d/modules

# Ajout de la partition dans /etc/fstab
echo -e  "\n/dev/md1p1 /mnt/backup 	ext3 	noatime 0 1\n" >> /etc/fstab
