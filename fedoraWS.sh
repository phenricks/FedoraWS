#!/bin/bash

##### ======================================================================== #####
##### NOME:              fedoraWS                                              #####
##### VERSÃO:            v1.0t                                                 #####
##### DATA DA CRIAÇÃO:   19/02/2022                                            #####
##### ESCRITO POR:       Pedro Henrique                                        #####
##### DISTRO:            Fedora 35                                             #####
##### PROJETO:           https://github.com/phenricks                          #####
##### ======================================================================== #####

ECLIPSE="https://espejito.fder.edu.uy/eclipse/oomph/epp/2021-12/R/eclipse-inst-jre-linux64.tar.gz"
IREPORT="https://sonik.dl.sourceforge.net/project/ireport/iReport/iReport-5.6.0/iReport-5.6.0.zip"

DIR_DOWNLOADS="$HOME/Downloads/Apps"

APPS_TO_INSTALL=(
    gnome-tweak-tool
    xrdp
    tigervnc-server
    java-1.8.0-openjdk
    java-11-openjdk
    google-chrome-stable
    flameshot
)

updateSystem() {
    sudo dnf check-upgrade
    sudo dnf -y upgrade
}
rpmExtra() {
    sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf -y install https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
}

updateSystem

rpmExtra

updateSystem

mkdir $DIR_DOWNLOADS
mkdir $HOME/Apps


wget -c "$ECLIPSE" -P "$DIR_DOWNLOADS"
wget -c "$IREPORT" -P "$DIR_DOWNLOADS"


tar xvzf $DIR_DOWNLOADS/*.tar.gz -C $HOME/Apps
unzip $DIR_DOWNLOADS/*.zip -d $HOME/Apps

for programa in ${APPS_TO_INSTALL[@]}; do
	if ! dnf list installed | grep -i $programa; then
		echo -e "\033[0;33m[INSTALANDO: $programa]\033[0m"
		sudo dnf install "$programa" -y
	else
		echo -e "\033[0;32m[INSTALADO]\033[0m - $programa"
	fi
done

clear

cd $HOME/Apps/eclipse-installer
./eclipse-inst
cd $HOME/Apps
rm -rf $HOME/Apps/eclipse-installer

mv ./extras/fonts $HOME
sudo systemctl enable --now xrdp
firewall-cmd --add-port=3309/tcp
firewall-cmd --runtime-to-permanent