#!/bin/bash

cd "$( dirname "$0")"

## GLOBAL VAR

CURRENT_DIR="$(pwd)"
YUM_REPO="/etc/yum.repos.d"
VBOX_URL="http://download.virtualbox.org/virtualbox/rpm/fedora/"
VBOX_REPO="virtualbox.repo"
VBOX="VirtualBox-5.0"
FEDY="http://folkswithhats.org/fedy-installer"
FLASH_URL="http://linuxdownload.adobe.com/adobe-release"
FLASH_RPM="adobe-release-x86_64-1.0-1.noarch.rpm"
FLASH_GPG="/etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux"
SPOOTY_REPO="http://negativo17.org/repos/fedora-spotify.repo"
FUSION_RPM="http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm"
SPOOTY_PKG="spotify-client"
GIT_HUB="https://github.com"
VIM_BUNDLE_DIR="/$HOME/.vim/bundle"

# BANNER

echo " Fedora 24 Customization Script "
echo " ==============================="
echo " v 0.1 "
echo ""
echo -n
echo -e "\e[1;31m !! Be sure to perform a ndf update before lunch this script !! \e[0m"

## CONTROL USER

echo -n
if [ $UID -ne 0 ]; then
    echo -e "\e[1;31m Please Run This Script As ROOT! \e[0m"
else
    echo -e "\e[1;32m You Are Root :) \e[0m"
fi

## DEPS INSTALL

dep=(
wget
git
vim
)

echo -n
echo -e "\e[1;32m Installing RPM FUSION,WGET,CURL,GIT and VIM ... \e[0m"

function install_dep()
{
    rpm -ivh "$FUSION_RPM" &> /dev/null
    for i in "${dep[@]}"
    do
        dnf install $i -y  &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

install_dep

###
## PACKAGE GROUPS
###

## VIRTUALBOX 5.0 DEPS
vbox=(
binutils 
gcc 
make 
patch 
libgomp 
glibc-headers 
glibc-devel 
kernel-headers
kernel-devel 
dkms
kernel-PAE-devel
)

## UTILS
utilz=(
gnome-tweak-tool
redshift
libreoffice
filezilla
terminator
wine
keepassx
homebank
bleachbit
vlc
whireshark
)

## JAVA BROWSER PLUGIN
browser=(
java-openjdk
icedtea-web
)

## VIDEO PLUGINS
plugins=(
gstreamer1-plugins-base 
gstreamer1-plugins-good 
gstreamer1-plugins-ugly
gstreamer1-plugins-bad-free 
gstreamer1-plugins-bad-free
gstreamer1-plugins-bad-freeworld 
gstreamer1-plugins-bad-free-extras 
ffmpeg
)

## COMPRESSIONS UTILS
zip=(
p7zip 
p7zip-plugins 
unrar
)

## FLASH PLAYER
flash=(
flash-plugin 
alsa-plugins-pulseaudio 
libcurl
)

## FUNCTIONS  

function install_vbox()
{
    echo -e "\e[1;32m Installing VirtualBox 5.1 ... \e[0m"
    cd "$YUM_REPO"
    wget "$VBOX_URL/$VBOX_REPO" > /dev/null 2>&1
    for i in "${vbox[@]}"
    do
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    dnf install -y dnf "$VBOX" &> /dev/null
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_utilz()
{
    echo -e "\e[1;32m Installing Utils ... \e[0m"
    for i in "${utilz[@]}"
    do
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_plugins()
{
    echo -e "\e[1;32m Installing video/audio codec ... \e[0m"
    for i in "${plugins[@]}"
    do
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_zip()
{
    echo -e "\e[1;32m Installing zip utils ... \e[0m"
    for i in "${zip[@]}"
    do
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_browser()
{
    echo -e "\e[1;32m Installing java browser plugins ... \e[0m"
    for i in "${browser[@]}"
    do 
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_fedy()
{
    echo -e "\e[1;32m Installing Fedy ... \e[0m"
    echo -e "\e[1;32m Fedy allow you to install additional software... \e[0m"
    cd "$CURRENT_DIR"
    curl "$FEDY" -o fedy-installer
    chmod +x fedy-installer
    ./fedy-installer > /dev/null 2>&1
    echo -e "\e[1;32m Done ! \e[0m" 
}

function install_flash()
{
    echo -e "\e[1;32m Installing flash plugin ... \e[0m"
    rpm -ivh "$FLASH_URL"/"$FLASH_RPM"
    rpm --import "$FLASH_GPG"
    for i in "${flash[@]}"
    do
        dnf install $i -y &> /dev/null; echo " Installing Deps ...."
    done
    echo -e "\e[1;32m Done ! \e[0m"
}

function install_spotify()
{
    echo -e "\e[1;32m Installing Spotify ... \e[0m"
    dnf config-manager --add-repo="$SPOOTY_REPO" &> /dev/null
    dnf install -y "$SPOOTY_PKG" &> /dev/null
    echo -e "\e[1;32m Done ! \e[0m"
}

## MENU

while true
do
    clear
    echo "Choose an Item ... "
    echo "1: VirtualBox (5.0)"
    echo "2: System Utilities"
    echo "3: Audio/Video Encoders"
    echo "4: Zip Utils"
    echo "5: Java For Browser"
    echo "6: Fedy"
    echo "7: Flash Plugin"
    echo "8: Spotify"
    echo "0: Exit"
    read -sn1
    case "$REPLY" in
        1) install_vbox;;
        2) install_utilz;;
        3) install_plugins;;
        4) install_zip;;
        5) install_browser;;
        6) install_fedy;;
        7) install_flash;;
        8) install_spotify;;
        0) exit 0;;
    esac
    read -n1 -p "Press any key to continue"
done
