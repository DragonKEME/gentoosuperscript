# Gentoo install superscript

Ce script pemet d'obtenir la vm finale de l'examen des apprentis (celui sur celene)

## Prérequis
- Tous les fichier de l'examen (l'iso, stage3, portage, distfiles, packages)
- Une vm qui boot sur l'iso de gentoo

Une fois l'iso démarré vous devez activer sshd `/etc/init.d/sshd start` et changer de password `passwd`

## Démarrage
Tout les fichiers, sauf l'iso, on n'en a pas besoin, doivent être dans le repertoire `/root`
- `scp dossier_avec_vos_fichier/* root@gento_ip:/root`

On passe tous les script en exécutable 
- `chmod +x *.sh`

On peut enfin exécuter les scripts
- `./gentoo-install-...`

# Ordre d'execution
Pour arriver à la vm finale sans erreur les script doivent être executé dans ce sens 
- `./gentoo-install-first-step.sh`

Une fois dans le chroot (votre prompt affiche `quelquechose + / #`) : 
- `./gentoo-install-portage-files.sh`
- `./gentoo-install-after-chroot.sh`
- `./gentoo-install-raid.sh`
- `./gentoo-install-lvm.sh`
- `./gentoo-install-gen-certificate.sh`

Pour gagner du temps vous pouvez décommenter les appels aux différents script dans `gentoo-install-after-chroot.sh`

### Des explication sur les commandes sont dans les script, mais n'hésitez à demander si vous avez une question