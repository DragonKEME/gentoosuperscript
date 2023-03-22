# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#

#============================================= PARAMS =============================================
# Nom du disque dur dans /dev
dev="sda"

# Type de système de fichier
# Note : utilisation du ext4 car plus récent mais peut être changer par de l'ext3
sf="ext4"

#============================================= SCRIPT =============================================

# ==== Création des systèmes de fichier =====
# Doc: https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation/fr#Cr.C3.A9er_des_syst.C3.A8mes_de_fichiers

# Partitionnement du disque
fdisk /dev/$dev < fdisk.comand

# Formatage des système de fichier et du swap
mke2fs -t $sf /dev/${dev}1
mke2fs -t $sf /dev/${dev}2
mkswap /dev/${dev}3

# Montage des partitions nouvellement formatée
mount /dev/${dev}2 /mnt/gentoo
sleep 1
mkdir /mnt/gentoo/boot
mount /dev/${dev}1 /mnt/gentoo/boot
sleep 1

# Déplacement des fichiers dans le nouveau système
mv * /mnt/gentoo
cd /mnt/gentoo

# Extraction de stage3
# Note: Stage3 contient tout les fichiers utile au système d'exploitation et quelque application précompilé utile (cd, ls, sshd...)
tar -xJf stage3-amd*

# ==== Préparation au chroot ====
# Doc: https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation/fr#Monter_les_syst.C3.A8mes_de_fichiers_n.C3.A9cessaires
# Processus et configuration du noyaux
mount --types proc /proc /mnt/gentoo/proc
sleep 1

# Same /proc
mount --rbind /sys /mnt/gentoo/sys
sleep 1

# Montage des périphériques
mount --rbind /dev /mnt/gentoo/dev
sleep 1

# Montage des fichiers d'execution des applications
mount --bind /run /mnt/gentoo/run
sleep 1

# Copie du fichier contenant les DNS
# Doc: https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation/fr#Copier_les_informations_DNS
cp -L /etc/resolv.conf /mnt/gentoo/etc/

# ==== Chroot ====
chroot /mnt/gentoo /bin/bash

# Suite dans gentoo-install-after-chroot.sh