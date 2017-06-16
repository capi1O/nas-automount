
**nas-automout** is a mac tool to easily setup in Finder samba (SMB/CIFS) and AFP shares❋, typically on a NAS (Network Attached Storage). It is composed of two apps : the first sets up a second app, which can be distributed to multiple users.

Both apps are quick and dirty made with Automator and use embedded bash scripts (and Applescripts).

❋ *all protocols supported by Finder*

# use

![screencast]()

## 1. setup (admin side)

The first app `generate-nas-automount-app.app` is used to generate an app that can be distributed to users that will setup NAS connections specific for each users.
It uses a JSON file as input to get the list of shares accessible by 1 or more users. See an example at example/shares.json.

- define the shares for a user in a JSON file named `shares.json`. ex for a share smb://nas.example.com/share-1 :

	```
	{
	    "name": "Share-1",
			"fstype": "smbfs",
	    "protocol": "smb",
	    "server": "nas.example.com",
	    "path": "share-1"
	}
	```
	*Note : avoid space in share name.*

	Optionally a login/password can be set (per share) but it is not recommended (password are stored in clear).

- run the first app `generate-nas-automount-app.app` and chose a name for the generated app (this app can be specific to a user or the same for multiple users using the same shares, see below).  *You will be asked if you want to force the creation of shortcuts in Finder sidebar when the user will run the generated app. If choosing no, user will be asked if he wants shortcuts or not when running the generated app.*

### about credentials (login/password)

- *If some shares defined in the JSON file have no credentials, the user will be prompted to enter his credentials when running the generated app `nas-automount-%name%.app`. This credentials will be used for all the shares where none is defined.
In the case where none of the shares have credentials, the app can be distributed to multiple users using the same shares.* 

- *If credentials are defined for every share in the JSON file, the user will not be prompted for his credentials (only for his system password). However in this case the generated app `nas-automount-%username%.app` would be specific to this user*.


## 2. install (user side)

The second app `nas-automount-%username%.app` can now be distributed to users.

- run the app `nas-automount-%username%.app`
- enter the login/password (if needed, see above)
- enter the system password (required)
- choose wether or not to create shortcuts in Finder sidebar (if needed)


# why

The default way to connect to remote shares on mac is cumbersome, every time the server (NAS) connection is lost, the user has to manually reconnect, plus there is an annoying dialog.

Using `/etc/auto_master` file to auto mount shares is a great alternative but for many users the terminal is obscure, even running a bash script can be daunting to non-technical people (need to `chmod` etc...).

That's why I made this simple app that a network administrator can easily send to all NAS users, and it just needs to be double clicked.

# dependencies

- [jq](https://github.com/stedolan/jq). `brew install jq` in terminal.


# sources

The generated `nas-automount-%username%.app` is essentially a wrapper for a bash script made from the commands listed in this blog post : http://blog.grapii.com/2015/06/keep-network-drives-mounted-on-mac-os-x-using-autofs/

# helpful resources

## Workflow

- https://apple.stackexchange.com/questions/222718/passing-arguments-to-run-shell-script-in-automator
- https://discussions.apple.com/thread/2756711?tstart=0
- https://apple.stackexchange.com/questions/23725/is-automator-intended-to-create-distributable-stand-alone-apps

- https://discussions.apple.com/thread/4464571?start=0&tstart=0
- https://moonsharke.wordpress.com/2011/06/03/multiple-variables-for-automators-run-applescript-action/
- https://apple.stackexchange.com/questions/97502/my-automator-workflow-fails-because-it-fails-to-find-the-git-command-within-the

## Applescript

- https://discussions.apple.com/thread/2571517?tstart=0
- http://stackoverflow.com/questions/24918497/applescript-run-bash-script-from-same-directory
- https://apple.stackexchange.com/questions/101258/get-components-path-and-filename-of-posix-filepath
- https://arstechnica.com/civis/viewtopic.php?f=20&t=60995
- http://macscripter.net/viewtopic.php?id=4913

## bash

- http://stackoverflow.com/questions/37710718/concat-2-fields-in-json-using-jq
- http://stackoverflow.com/questions/35677309/looping-through-an-array-with-jq-for-json-on-the-command-line
- http://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
- https://stedolan.github.io/jq/manual/v1.4/#ConditionalsandComparisons
- https://superuser.com/questions/90008/how-to-clear-the-contents-of-a-file-from-the-command-line
- https://unix.stackexchange.com/a/129401


## other

- https://www.jamf.com/jamf-nation/discussions/18894/how-to-add-a-shortcut-to-the-finder-sidebar


# code

## structure

`generate-nas-automount-app.app` is an automator workflow composed of Applescripts, set/get value actions and a bash script. Copies of those files are visible under the source directory :
- `source/generate-nas-automount-app-1.scpt`
- `source/generate-nas-automount-app-2.scpt`
- `source/generate-nas-automount-app.sh`

`nas-automount-%username%.app` is also an automator workflow composed of an Applescript followed by a bash script, but the bash script is generated by `generate-nas-automount-app.app`. A copy of the Applescript is visible under the source directory and an example of the generated bash script is provided under the example directory :

- `source/nas-automount-template.scpt`   
- `example/nas-automount.sh`

Those files are only copies of their embedded versions and are only provided as guidance. They do not work outside of their app (incorrect path etc...).

## contributing

This project adheres to the Contributor Covenant [code of conduct](code-of-conduct.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior to monkeydri@github.com.
