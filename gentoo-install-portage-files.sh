# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#

#============================================= PARAMS =============================================
# Nom des fichiers
portage="portage-latest.tar.bz2"
distfile="portage-latest.tar.bz2"
packages="packages.tar.bz2"

#============================================= SCRIPT =============================================

# Installation de portage 
mv $portage /usr/
cd /usr/
tar -xvf $portage

# Ajout des repos
ln -s /usr/portage /var/db/repos/gentoo
cd /

# Paquet précompilé et téléchargé
mv $distfile /var/cache/
mv $packages /var/cache/
cd /var/cache
tar -xvf $packages
tar -xvf $distfile
cd /
