#!/bin/bash

mkdir $1

wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks

WINEPREFIX=$1 wineboot

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "10" >> $1/progress.mimifile

WINEPREFIX=$1 ./winetricks win10

curl -L "https://drive.google.com/uc?export=download&id=1qcmyHzWerZ39OhW0y4VQ-hOy7639bJPO" > allredist.tar.xz
mkdir allredist

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "20" >> $1/progress.mimifile

tar -xf allredist.tar.xz

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "25" >> $1/progress.mimifile

curl -L "https://spyderrock.com/kMnq2220-AdobePhotoshop2021.xz" > AdobePhotoshop2021.tar.xz

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "50" >> $1/progress.mimifile

tar -xf AdobePhotoshop2021.tar.xz

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "70" >> $1/progress.mimifile

WINEPREFIX=$1 ./winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk win10 vkd3d

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "80" >> $1/progress.mimifile

WINEPREFIX=$1 wine allredist/redist/2010/vcredist_x64.exe /q /norestart
WINEPREFIX=$1 wine allredist/redist/2010/vcredist_x86.exe /q /norestart

WINEPREFIX=$1 wine allredist/redist/2012/vcredist_x86.exe /install /quiet /norestart
WINEPREFIX=$1 wine allredist/redist/2012/vcredist_x64.exe /install /quiet /norestart

WINEPREFIX=$1 wine allredist/redist/2013/vcredist_x86.exe /install /quiet /norestart
WINEPREFIX=$1 wine allredist/redist/2013/vcredist_x64.exe /install /quiet /norestart

WINEPREFIX=$1 wine allredist/redist/2019/VC_redist.x64.exe /install /quiet /norestart
WINEPREFIX=$1 wine allredist/redist/2019/VC_redist.x86.exe /install /quiet /norestart

rm -rf $1/progress.mimifile
touch $1/progress.mimifile
echo "90" >> $1/progress.mimifile


mkdir $1/drive_c/Program\ Files/Adobe
mv Adobe\ Photoshop\ 2021 $1/drive_c/Program\ Files/Adobe/Adobe\ Photoshop\ 2021

touch $1/drive_c/launcher.sh
echo '#!/usr/bin/env bash' >> $1/drive_c/launcher.sh
echo 'SCR_PATH="pspath"' >> $1/drive_c/launcher.sh
echo 'CACHE_PATH="pscache"' >> $1/drive_c/launcher.sh
echo 'RESOURCES_PATH="$SCR_PATH/resources"' >> $1/drive_c/launcher.sh
echo 'WINE_PREFIX="$SCR_PATH/prefix"' >> $1/drive_c/launcher.sh
echo 'FILE_PATH=$(winepath -w "$1")' >> $1/drive_c/launcher.sh
echo 'export WINEPREFIX="'$1'"' >> $1/drive_c/launcher.sh
echo 'WINEPREFIX='$1' DXVK_LOG_PATH='$1' DXVK_STATE_CACHE_PATH='$1' wine64 ' $1'/drive_c/Program\ Files/Adobe/Adobe\ Photoshop\ 2021/photoshop.exe $FILE_PATH' >> $1/drive_c/launcher.sh

chmod +x $1/drive_c/launcher.sh

WINEPREFIX=$1 winecfg -v win10

mv allredist/photoshop.png ~/.local/share/icons/photoshop.png

# Included mimetypes for default handlers
# Updated name, comment and categories

touch ~/.local/share/applications/photoshop.desktop
echo '[Desktop Entry]' >> ~/.local/share/applications/photoshop.desktop
echo 'Name=Adobe Photoshop CC 2021' >> ~/.local/share/applications/photoshop.desktop
echo 'Exec=bash -c "'$1'/drive_c/launcher.sh %F"' >> ~/.local/share/applications/photoshop.desktop
echo 'Type=Application' >> ~/.local/share/applications/photoshop.desktop
echo 'Comment=The industry-standard photo editing software (Wine)' >> ~/.local/share/applications/photoshop.desktop
echo 'Categories=Graphics;Photography;' >> ~/.local/share/applications/photoshop.desktop
echo 'Icon=photoshop' >> ~/.local/share/applications/photoshop.desktop
echo 'MimeType=image/psd;image/x-psd;' >> ~/.local/share/applications/photoshop.desktop
echo 'StartupWMClass=photoshop.exe' >> ~/.local/share/applications/photoshop.desktop

rm -rf allredist
rm -rf winetricks

echo "100" >> $1/progress.mimifile
rm -rf $1/progress.mimifile
