#! /bin/bash
base_path="${1}"
# path to embedded bash script (into nas-automount.app)
app_bash_script="${base_path}nas-automount.app/Contents/Resources/nas-automount.sh"
shares_json="${base_path}shares.json"

# get force_shortcuts value
force_shortcuts="${2}"

# clear or create embedded bash script
> $app_bash_script

# add lines to set the desired behavior to add shortcuts to shares in Finder sidebar
# if force_shortcuts set, shortcuts will be created.
# if force_shortcuts not set, user will be asked if he wants to create shortcuts or not.
if [ "${force_shortcuts}" = true ]
then
	echo 'create_shortcuts=true' >> $app_bash_script
else
	echo 'create_shortcuts=false' >> $app_bash_script
fi

# add lines to get username & password (if needed) and shortcut value as options
echo 'while getopts ":u:p:s" opt; do' >> $app_bash_script
echo '	case $opt in' >> $app_bash_script
echo '		u) username="$OPTARG"' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '		p) password="$OPTARG"' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '		s) create_shortcuts=true' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '		\?)' >> $app_bash_script
echo '		echo "Invalid option: -$OPTARG" >&2' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '	esac' >> $app_bash_script
echo 'done' >> $app_bash_script


# add line to add one line to /etc/auto_master file
echo 'echo "/mnt/nas		auto_nas" >> /etc/auto_master' >> $app_bash_script

# for each share defined in shares.json file add a line to add a line to /etc/auto_nas
jq -r '.[] | ("echo \"" + .name + " -fstype=" + .protocol + " '"'"'" + .protocol + "://" + (.username // "$username") + ":" + (.password // "$password") +"@" + .server + "/" + .path + "'"'"'\" >> /etc/auto_nas")' "${shares_json}" >> $app_bash_script

# add lines to make auto_nas file root-only
echo 'chown root /etc/auto_nas' >> $app_bash_script
echo 'chmod 600 /etc/auto_nas' >> $app_bash_script

# add line to create mount directory
echo 'mkdir -p /mnt/nas' >> $app_bash_script

# add line to mount the shares
echo 'automount -vc' >> $app_bash_script

# add shortcuts to Finder sidebar
echo 'if [ "${create_shortcuts}" = true ]' >> $app_bash_script
echo 'then' >> $app_bash_script
echo '	:' >> $app_bash_script
# for each share defined in shares.json file add a line to add a shortcut to the Finder sidebar
jq -r '.[] | ("	sfltool add-item com.apple.LSSharedFileList.FavoriteItems '"'"'file:///mnt/nas/" + .name + "'"'"'")' "${shares_json}" >> $app_bash_script
echo 'fi' >> $app_bash_script