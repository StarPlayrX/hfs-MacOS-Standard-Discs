#!/bin/sh

#sudo /Volumes/hfs_std/hfs.sh

#Brings back HFS Standard (Pre HFS+ disks back to Catalina)

destVolume="/"
source="$(pwd)/Resources/"
read -p "
Enables HFS Standard Disks in Catalina (Do not use on BigSur):

Destination Volume [ $destVolume = return key | drag volume here -> ]: " destVolume2

read -p "Resources Folder   [ $source = return key ]: " source2

if [ "$destVolume2" != "" ]
 then
   destVolume="$destVolume2"
fi

if [ "$destVolume" == "/" ]
  then
    mount -o rw -uw $destVolume
fi

if [ "$source2" != "" ]
  then
    source="$source2"
fi

echo "
Resources --> $source"
echo "Dest.     --> $destVolume
"

read -p "Press return to proceed:" proceed

kext="/System/Library/Extensions/"
libKext="/Library/Extensions/"
plugins="/System/Library/UserEventPlugins/"

libDest=$destVolume$libKext
dest=$destVolume$kext

userEventPlugins=$destVolume$plugins

wild="/*"


#HFS Legacy
HFS="HFS.kext"
echo "\r\nUninstalling $HFS..."
rm -PR "$dest$HFS"

#HFS Legacy Support (Pre HFS+ discs)
HFSEncodings="HFSEncodings.kext"
echo "\r\nUninstalling $HFSEncodings..."
rm -PR "$dest$HFSEncodings"

#ATA
IOATAFamily="IOATAFamily.kext"
echo "\r\nUninstalling $IOATAFamily..."
rm -PRf "$dest$IOATAFamily"

echo "\r\nInstalling Legacy Mac OS Standard | HFS (Mojave)..."
ditto -v "$source$HFS" "$dest$HFS"
chmod -R 755 "$dest$HFS"
chown -R 0:0 "$dest$HFS"

echo "\r\nInstalling Legacy Mac OS Standard | Encodings (Mojave)..."
ditto -v "$source$HFSEncodings" "$dest$HFSEncodings"
chmod -R 755 "$dest$HFSEncodings"
chown -R 0:0 "$dest$HFSEncodings"

echo "\r\nInstalling ATA | SuperDrive (Catalina Developer Beta 2)..."
ditto -v "$source$IOATAFamily" "$dest$IOATAFamily"
chmod -R 755 "$dest$IOATAFamily"
chown -R 0:0 "$dest$IOATAFamily"


if [ "$destVolume" == "/" ]
then
  echo "\r\nUpdating System Prelinked Kernel...\r\n"
    kextcache -system-prelinked-kernel
  echo "\r\nUpdating System Caches...\r\n"
    kextcache -system-caches
  else
    echo "\r\nUpdating kextcache on volume $destVolume...\r\n"
      kextcache -u "$destVolume"
    echo "\r\nUpdating startup kextcache check on volume $destVolume...\r\n"
      kextcache -U "$destVolume"
fi

echo "\r\nThis script was brought to you by StarPlayrX,\r\niOS SiriusXM Radio Player, available in on iOS AppStore.\r\n"

read -p "Press return to Reboot [ options : q for quick ]: " rebootArgs
echo "\r\n"

if [ "$rebootArgs" != "" ]
then
    reboot "-$rebootArgs"
else
    reboot
fi

#MP31_CatWoman Patch Enables:


#Legacy Mac OS Standard HFS Encodings fix discovered by StarPlayrX. This patch uses Legacy HFS Kext's from Mojave.
#StarPlayrX takes absolutely no credit for the patchers in this tool.
#This Cat Woman patch was compiled free of charge and is for anyone to use.
#Designed on a 2008 Mac Pro in Charlotte, North Carolina