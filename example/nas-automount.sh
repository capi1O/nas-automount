#! /bin/bash

# get username & password (if needed) as options
while getopts ":u:p:" opt; do
	case $opt in
		u) username="$OPTARG"
		;;
		p) password="$OPTARG"
		;;
		\?)
		echo "Invalid option: -$OPTARG" >&2
		;;
	esac
done

# add one line to /etc/auto_master file
echo "/mnt/nas		auto_nas" >> /etc/auto_master

# add share lines to /etc/auto_nas file
echo "Time Machine -fstype=afp 'afp://$username:$password@nas.example.com/time machine'" >> /etc/auto_nas
echo "Share 1 -fstype=afp afp://user:secret@nas.example.com/share-1" >> /etc/auto_nas
echo "Share 2 -fstype=smbfs smb://$username:$password@nas.example.com/share-2" >> /etc/auto_nas


# make auto_nas file root-only
chown root /etc/auto_nas
chmod 600 /etc/auto_nas

# create mount directory
mkdir -p /mnt/nas

# mount the shares
automount -vc
