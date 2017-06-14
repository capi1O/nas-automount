#! /bin/bash

# path to embedded bash script (into nas-automount.app)
app_bash_script=$1

# clear or create embedded bash script
> $app_bash_script

# add lines to get username & password (if needed) as options
echo 'while getopts ":u:p:" opt; do' >> $app_bash_script
echo '	case $opt in' >> $app_bash_script
echo '		u) username="$OPTARG"' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '		p) password="$OPTARG"' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '		\?)' >> $app_bash_script
echo '		echo "Invalid option: -$OPTARG" >&2' >> $app_bash_script
echo '		;;' >> $app_bash_script
echo '	esac' >> $app_bash_script
echo 'done' >> $app_bash_script


# add line to add one line to /etc/auto_master file
echo 'echo "/mnt/nas		auto_nas" >> /etc/auto_master' >> $app_bash_script

# for each share defined in shares.json file add a line to add a line to /etc/auto_nas
jq -r '.[] | ("echo \"" + .name + " -fstype=" + .protocol + " '"'"'" + .protocol + "://" + (.username // "$username") + ":" + (.password // "$password") +"@" + .server + "/" + .path + "'"'"'\" >> /etc/auto_nas")' shares.json >> $app_bash_script

# add lines to make auto_nas file root-only
echo 'chown root /etc/auto_nas' >> $app_bash_script
echo 'chmod 600 /etc/auto_nas' >> $app_bash_script

# add line to create mount directory
echo 'mkdir -p /mnt/nas' >> $app_bash_script

# add line to mount the shares
echo 'automount -vc' >> $app_bash_script
