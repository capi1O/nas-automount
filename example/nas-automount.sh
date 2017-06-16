#! /bin/bash

# get username & password (if needed) and shortcut value as options
create_shortcuts=true
while getopts ":u:p:s" opt; do
	case $opt in
		u) username="$OPTARG"
		;;
		p) password="$OPTARG"
		;;
		s) create_shortcuts=true
		;;
		\?)
		echo "Invalid option: -$OPTARG" >&2
		;;
	esac
done

# add one line to /etc/auto_master file
echo "/mnt/nas		auto_nas" >> /etc/auto_master

# add share lines to /etc/auto_nas file
echo "Time-Machine -fstype=afp 'afp://$username:$password@nas.example.com/time machine'" >> /etc/auto_nas
echo "Share-1 -fstype=afp afp://user:secret@nas.example.com/share-1" >> /etc/auto_nas
echo "Share-2 -fstype=smbfs smb://$username:$password@nas.example.com/share-2" >> /etc/auto_nas


# make auto_nas file root-only
chown root /etc/auto_nas
chmod 600 /etc/auto_nas

# create mount directory
mkdir -p /mnt/nas

# mount the shares
automount -vc

# add shortcuts to Finder sidebar
if [ "${create_shortcuts}" = true ]
then
	:
	sfltool add-item com.apple.LSSharedFileList.FavoriteItems 'file:///mnt/nas/Time-Machine'
	sfltool add-item com.apple.LSSharedFileList.FavoriteItems 'file:///mnt/nas/Share-1'
	sfltool add-item com.apple.LSSharedFileList.FavoriteItems 'file:///mnt/nas/Share-2'
fi
