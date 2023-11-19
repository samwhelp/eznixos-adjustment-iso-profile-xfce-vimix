#!/usr/bin/env bash


################################################################################
### Head: Init
##
set -e ## for Exit immediately if a command exits with a non-zero status.
THE_BASE_DIR_PATH="$(cd -- "$(dirname -- "$0")" ; pwd)"
THE_CMD_FILE_NAME="$(basename "$0")"
##
### Tail: Init
################################################################################


################################################################################
### Head: PATH
##

THE_PLAN_DIR_PATH="${THE_BASE_DIR_PATH}"

##
### Tail: PATH
################################################################################


################################################################################
### Head: Option
##

THE_DEFAULT_RUN="${THE_DEFAULT_RUN:=make-iso}"

sys_default_run () {
	echo "${THE_DEFAULT_RUN}"
}

##
### Tail: Option
################################################################################


################################################################################
### Head: Model / Build ISO
##

mod_iso_build () {

	local to_run="$(sys_default_run)"

	local delegate="${THE_PLAN_DIR_PATH}/steps.sh"

	sudo THE_DEFAULT_RUN="${to_run}" THE_DEFAULT_DISTRO="main-xfce" "${delegate}"

}


##
### Tail: Model / Build ISO
################################################################################


################################################################################
### Head: Main
##
__main__ () {

	mod_iso_build

}

__main__
##
### Tail: Main
################################################################################

