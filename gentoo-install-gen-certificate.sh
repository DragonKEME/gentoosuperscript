# Gentoo install superscript (TD8 -> FISA)
# by @DragonKEME
#
# License DragonKEUM :
#   - Utilisation interdite devant les yeux du prof
#

#============================================= PARAMS =============================================
# Nom du certificat
# Note: server est le nom du certificat qui resout l'erreur
cert="server"

#============================================= SCRIPT =============================================
# Installation d'openssl
emerge openssl

# Création du dossier
mkdir /etc/ssl/apache2
cd /etc/ssl/apache2

# Génération de clé et du certificat et auto-signature du certificat
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out $cert.key
chmod 600 $cert.key
openssl req -new -key $cert.key -out $cert.csr
openssl x509 -req -days 365 -in $cert.csr -signkey $cert.key -out $cert.crt
