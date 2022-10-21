#!/bin/bash
#1Installation
#On met à jour les paquets et on upgrade
sudo apt-get update -y && sudoapt-get upgrade -y
#On installe proftpd ssh
sudo apt-get install ssh -y
sudo apt-get install proftpd -y

#2 Utilisateurs
#On crée 2 utilisateurs,le premier Merry et le deuxième Pippin
mdp1=$(perl -e 'print crypt("kalimac", "salt")')
mdp2=$(perl -e 'print crypt("secondbreakfast", "salt")')
sudo adduser--force-badname Merry
sudo adduser--force-badname Pippin
#On leurs donne ensuite leurs mots de passes
sudo useradd  -m -p $mdp1 Merry
sudo useradd  -m -p $mdp2 Pippin
#3 Configuration de Proftpd
#Commande pour configurer le Proftpd
cd /etc/proftpd
cp proftpd.conf proftpd.cof.save
#On définit le nombre maximum de client en simultané
echo -n"Nombre de clients en simultané"
read Maxclients
#On configure l'anonymous pour ce connecter en anonyme
<Anonymous ~ftp>
user ftp
group nogroup
UserAlias anonymous ftp
DirFakeUser on ftp
DirFakeGroup on ftp
RequireValidShell off
MaxClients 10
DisplayLogin welcome.msg
DisplayChdir .message

<Directory *>
<Limit WRITE>
AllowAll
</Limit>
</Directory>

<Directory incoming>
<Limit READ WRITE>
AllowAll
</Limit>
</Directory>
</Anonymous>

>>proftpd.conf

sudo systemctl restart proftpd
sudo systemctl status proftpd
