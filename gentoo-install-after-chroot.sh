# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#
# Note: Les appels au sous-script sont commentés afin d'éviter les cascades d'erreurs si quelque chose se passe mal, cependant ils doivent être appelés dans l'ordre
#       Vous pouvez les décommenter pour avoir directement la machine finale de l'annale.


#============================================ PREREQUIS ===========================================

# Installation des fichiers en plus (portage, distfile ...)
#./gentoo-install-portage-files.sh


#============================================= PARAMS =============================================
# Nom du disque dur dans /dev
dev="sda"

# Application à installer dans le système
apps=("gentoo-kernel-bin" "grub" "dhcpcd" "cronie" "syslog-ng" "apache" "proftpd" "lvm2" )

# Demons demarrer au demarage de la machine
bootapp=("sshd" "cronie" "syslog-ng" "apache2" "proftpd")

# Votre nom de machine
hostname="superscript"

# Nom de l'utilisateur à créer
username="exam1"
# Nom des groupes à ajouter à l'utilisateur
groups="users,wheel"

#============================================= SCRIPT =============================================

#===Installation des apps ===
env-update && source /etc/profile

# /!\ Pas en exam (+ garder -K a emerge) /!\ 
# On a déjà tout cela dans les différentes archives (portage.tar.bz2)
# Cette commande Télécharge la liste des applications disponibles sur le serveur (similaire à `apt update` ) mais en plus long /!\
#emerge --sync

# /!\ Pas en exam ajout des use flag for lvm
#echo 'USE="lvm lvm2create-initrd readline udev"' >> /etc/portage/make.conf

# Installation des applications dans la liste donnée
for a in ${apps[@]}; do
    emerge -K $a
done

# Emerge classique pour mdam car pas dans les paquets précompilés
emerge "mdadm"

# ==== Configuration ====

# Configuration de la timezone
# Doc: https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation/fr#OpenRC_2
echo "Europe/Paris" > /etc/timezone
emerge --config sys-libs/timezone-data


# Config sshd: Nécessaire pour se connecter en root par ssh
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Installation de GRUB
grub-install /dev/$dev
grub-mkconfig -o /boot/grub/grub.cfg

# Config fstab
# Tout est dans le fichier fstab.comand, il monte au démarrage les partitions créer précédemment (gentoo-install-)
cat fstab.comand > /etc/fstab

# Config du hostame
# Dans le fichier définissant le hostname
echo -e "hostname=\"$hostname\"" > /etc/conf.d/hostname
# Dans hosts pour pouvoir resoudre son propre nom (ex: ping $hostname)
echo -e "\n127.0.0.1  $hostname\n::1  $hostname\n" >> /etc/hosts

# Password du root 
# A rentrer manuellement (j'ai pas trouver d'autre solution pour l'instant)
# password: Azerty0$@
passwd

# Config pour le clavier français
# Le fichier keymap.comand est la copie du fichier /etc/conf.d/keymaps mais avec une configuration en français
cat keymap.comand > /etc/conf.d/keymaps

# Ajout des démon au démarrage depuis la liste
for ca in ${bootapp[@]}; do
    rc-update add $ca default
done

# Création de l'utilisateur
useradd -m -G $groups $username
# Idem root password
passwd $username

# Créer syslog config
# La configuration est similaire au td fait dessus juste le nom de fichier change
cat syslog.conf.comand >> /etc/syslog-ng/syslog-ng.conf

# Charger proftpd config
# Le fichier de configuration n'existe pas par default on met la sample configuration comme fichier de config
mv /etc/proftpd/proftpd.conf.sample /etc/proftpd/proftpd.conf

# Creation du cron
# Creation des dossier de test
mkdir -p /home/toto/data
echo "test" > /home/toto/data/file.txt
mkdir -p /mnt/backup

# Création du cron de backup automatique
echo "20 15  *  *  * root       /usr/bin/rsync -r /home/toto/data /mnt/backup/" > /etc/cron.d/backup.sh
chmod 600 /etc/cron.d/backup.sh

# Creation du raid
#./gentoo-install-raid.sh

# Creation du lvm
#./gentoo-install-lvm.sh

# En plus: Création de certificat openssl pour gérer l'erreur d'apache
#./gentoo-install-gen-certificate.sh