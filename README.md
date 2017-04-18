
**nas-automout** is a mac app to easily setup samba (SMB/CIFS) and AFP shares❋, typically on a NAS (Network Attached Storage). It is composed of two apps : the first sets up a second app, which can be shared to multiple users.

Both apps are quick and dirty made with Automator and use embedded bash scripts (and Applescripts).

❋ *all protocols supported by Finder*

# use

![screencast]()

## 1. setup (admin side)

The first app `generate-nas-automount-app.app` is used to generate a customized app that can be distributed to users.

- define the shares in file `shares.json`. ex for a share smb://nas.example.com/share-1 :

	```
	{
	    "name": "Share 1",
	    "protocol": "smb",
	    "server": "nas.example.com",
	    "path": "share-1"
	}
	```

	Optionally a login/password can be set (per share) but it is not recommended (password are stored in clear).

- run the first app `generate-nas-automount-app.app`.

### about login/password

- *If no login/password is defined, the user will be prompted to enter his credentials when running the generated app `nas-automount.app`. In this case the same app `nas-automount.app` can be shared to multiple users.*

- *If logins/passwords are defined for each share, the user will not be prompted for his credentials (only for his system password). However in this case the generated app `nas-automount.app` would be specific to each user*.

*(this login/password will be used for all shares in `shares.json` where no login/password is not defined)*.


## 2. install (user side)

The second app `nas-automount.app` can now be distributed to users.

- run the app `nas-automount.app`
- enter the login/password (if needed)
- enter the system password (required)



# why

The default way to connect to remote shares on mac is cumbersome, every time the server (NAS) connection is lost, the user has to manually reconnect, plus there is an annoying dialog.

Using `/etc/auto_master` file to auto mount shares is a great alternative but for many users the terminal is obscure, even running a bash script can be daunting to non-technical people (need to chmod etc...).

That's why I made this simple app that a network administrator can easily send to all NAS users, and it just needs to be double clicked.

# dependencies

- [jq](https://github.com/stedolan/jq). `brew install jq` in terminal.


# sources

**nas-automount** is essentially a wrapper for a bash script made from the commands listed in this blog post : http://blog.grapii.com/2015/06/keep-network-drives-mounted-on-mac-os-x-using-autofs/

# helpful resources

## Workflow

- https://apple.stackexchange.com/questions/222718/passing-arguments-to-run-shell-script-in-automator
- https://discussions.apple.com/thread/2756711?tstart=0
- https://apple.stackexchange.com/questions/23725/is-automator-intended-to-create-distributable-stand-alone-apps

- https://discussions.apple.com/thread/4464571?start=0&tstart=0
- https://moonsharke.wordpress.com/2011/06/03/multiple-variables-for-automators-run-applescript-action/

## Applescript

- https://discussions.apple.com/thread/2571517?tstart=0
- http://stackoverflow.com/questions/24918497/applescript-run-bash-script-from-same-directory
- https://apple.stackexchange.com/questions/101258/get-components-path-and-filename-of-posix-filepath
- https://arstechnica.com/civis/viewtopic.php?f=20&t=60995

## bash

- http://stackoverflow.com/questions/37710718/concat-2-fields-in-json-using-jq
- http://stackoverflow.com/questions/35677309/looping-through-an-array-with-jq-for-json-on-the-command-line
- http://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
- https://stedolan.github.io/jq/manual/v1.4/#ConditionalsandComparisons
- https://superuser.com/questions/90008/how-to-clear-the-contents-of-a-file-from-the-command-line
- https://unix.stackexchange.com/a/129401

# code

The files `generate-nas-automount-app.scpt`, `generate-nas-automount-app.sh`, `nas-automount.scpt` and `nas-automount.sh` are copies of their embedded versions (inside `generate-nas-automount-app.app` and `nas-automount.app`) and are only provided as guidance. They might not work out of their app due to path being incorrect.

## contributing

This project adheres to the Contributor Covenant [code of conduct](code-of-conduct.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior to monkeydri@github.com.
