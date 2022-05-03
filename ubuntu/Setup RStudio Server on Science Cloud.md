# Update Installation

```
sudo apt-get update
sudo apt-get upgrade
```

# basic tools

```
sudo apt-get install mc
sudo apt-get install zile
````

# Install newest R version 
[http://cran.rstudio.com/bin/linux/ubuntu/](http://cran.rstudio.com/bin/linux/ubuntu/)

## Preparations

```
# update indices
sudo apt update -qq
# install two helper packages we need
sudo apt install --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
```

## Install R
```
sudo apt install \
r-base \
r-base-dev \
liblapack-dev \
liblapack3 \
libopenblas-base \
libopenblas-dev  
```

# Install build tools to compile packages

[https://www.osradar.com/install-development-build-tools-ubuntu-20-04/](https://www.osradar.com/install-development-build-tools-ubuntu-20-04/)
```
sudo apt install build-essential
```

# Install RStudio server
[https://www.rstudio.com/products/rstudio/download-server/debian-ubuntu/](https://www.rstudio.com/products/rstudio/download-server/debian-ubuntu/)
```
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.1-372-amd64.deb
sudo gdebi rstudio-server-2021.09.1-372-amd64.deb
```


# Prepare and packages via apt and install some basic packages

```
add-apt-repository ppa:c2d4u.team/c2d4u4.0+
sudo apt install \
r-cran-data.table \ 
r-cran-desolve \
r-cran-devtools \
r-cran-doparallel \ 
r-cran-earlywarnings \
r-cran-foreach \ 
r-cran-ggpubr \ 
r-cran-ggtext \ 
r-cran-here \
r-cran-kableextra \ 
r-cran-lme4 \ 
r-cran-lmertest \ 
r-cran-marss \ 
r-cran-nonlineartseries \
r-cran-patchwork \ 
r-cran-pracma \ 
r-cran-qs \
r-cran-rapiserialize \
r-cran-rcolorbrewer \ 
r-cran-rcppparallel \
r-cran-rmarkdown \
r-cran-rootsolve \
r-cran-stringfish \
r-cran-tidyverse \
r-cran-shiny \
r-cran-ggfortify
```

# Create Volume
[https://docs.s3it.uzh.ch/cloud/user_guide/4_create_and_manage_volumes/](https://docs.s3it.uzh.ch/cloud/user_guide/4_create_and_manage_volumes/)
Create the volume or use an existing volume and attach it to the instance

## format volume
This should ponly be done when using a new and emplty volume. 

**If it is done on an existing volume with data, all data will be deleted!**

 Identify volume by using
 
 ```
 sudo lsblk
 ```
 which returns for example
 
 ```
 NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0     7:0    0 55.5M  1 loop /snap/core18/2074
loop1     7:1    0 55.5M  1 loop /snap/core18/2253
loop2     7:2    0 61.9M  1 loop /snap/core20/1242
loop3     7:3    0 70.3M  1 loop /snap/lxd/21029
loop4     7:4    0 67.2M  1 loop /snap/lxd/21835
loop5     7:5    0 32.3M  1 loop /snap/snapd/12704
loop6     7:6    0 42.2M  1 loop /snap/snapd/14066
vda     252:0    0  100G  0 disk
├─vda1  252:1    0 99.9G  0 part /
├─vda14 252:14   0    4M  0 part
└─vda15 252:15   0  106M  0 part /boot/efi
vdb     252:16   0   50G  0 disk
```

In this example, the drive is `/dev/vdb/` and format it by using the following command. **Make sure that you select the right device as you can not undo this action!**
```
 sudo mkfs.ext4 -L RStudio_home /dev/vdb
```
 
 Now you can mount it by using e.g.
 
```
 sudo mount /dev/vdb /mnt
```
 
 and unmount it by using 

```
 sudo umount /mnt
```

# Setup automatic mounting of attached Volume

It is recommended to mount it automatically upon booting as outlined at at [https://docs.s3it.uzh.ch/how-to_articles/how_to_automatically_mount_a_volume_at_instance_startup/](https://docs.s3it.uzh.ch/how-to_articles/how_to_automatically_mount_a_volume_at_instance_startup/)


Create a directory to which the volume should be mounted

```
sudo mkdir /home_rstudio
sudo touch /home_rstudio/NOT_MOUNTED
```

Make a backup of the file `/etc/fstab`

```
sudo cp /etc/fstab /etc/fstab.old
```
use

```
sudo lsblk -o NAME,FSTYPE,UUID,SIZE,LABEL
```

to obtain the UUID of the volume. It is for examplke:

```
NAME    FSTYPE   UUID                                  SIZE LABEL
loop0   squashfs                                      55.5M
loop1   squashfs                                      55.5M
loop2   squashfs                                      61.9M
loop3   squashfs                                      70.3M
loop4   squashfs                                      67.2M
loop6   squashfs                                      42.2M
loop7   squashfs                                      61.9M
loop8   squashfs                                      43.3M
vda                                                    100G
├─vda1  ext4     075e8855-1060-4726-990b-e30daf3adb1d 99.9G cloudimg-rootfs
├─vda14                                                  4M
└─vda15 vfat     941F-05CE                             106M UEFI
vdb     ext4     743b569b-e81f-4618-ad79-86f59c80ffda  700G RStudio_home
```

The UUID is now `743b569b-e81f-4618-ad79-86f59c80ffda`.

Now put the fiollowing line at the end of the file /etc/fstab` by using any editor you prefer ( nano is pre-installed and probably the easiest):

```
UUID=<UUID> /home_rstudio ext4 rw,exec,noauto,x-systemd.automount,x-systemd.idle-timeout=300 0 0
```

where you replace `<UUID>` with the uuid identified above.

Important: At the end of the line you have to press return, i.e. the last line of the file needs to be an empty line!


# Create snapshot of the instance
Now you are all set and should create a snapshot of the image.

# Install SAMBA server and share home directories
TODO

See [https://ubuntu.com/tutorials/install-and-configure-samba#2-installing-samba](https://ubuntu.com/tutorials/install-and-configure-samba#2-installing-samba)

```
sudo apt install samba
```

and setup samba to share all user directories by following this manual at [https://www.howtogeek.com/howto/ubuntu/share-ubuntu-home-directories-using-samba/](https://www.howtogeek.com/howto/ubuntu/share-ubuntu-home-directories-using-samba/)


# Add User

```
sudo useradd -m -d /home_rstudio/NAME NAME

sudo passwd NAME PASSWORD

sudo smbpasswd -a NAME
```
