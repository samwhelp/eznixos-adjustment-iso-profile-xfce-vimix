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
### Head: Path
##

THE_BASE_ARCHISO_PROFILE_DIR_PATH="/usr/share/archiso/configs/releng"

THE_PLAN_DIR_PATH="${THE_BASE_DIR_PATH}"




THE_PLAN_TMP_DIR_NAME="tmp"
THE_PLAN_TMP_DIR_PATH="${THE_PLAN_DIR_PATH}/${THE_PLAN_TMP_DIR_NAME}"

THE_PLAN_WORK_DIR_NAME="work"
THE_PLAN_WORK_DIR_PATH="${THE_PLAN_TMP_DIR_PATH}/${THE_PLAN_WORK_DIR_NAME}"

THE_PLAN_OUT_DIR_NAME="out"
THE_PLAN_OUT_DIR_PATH="${THE_PLAN_TMP_DIR_PATH}/${THE_PLAN_OUT_DIR_NAME}"




THE_PLAN_PROFILE_DIR_NAME="profile"
THE_PLAN_PROFILE_DIR_PATH="${THE_PLAN_TMP_DIR_PATH}/${THE_PLAN_PROFILE_DIR_NAME}"

THE_PLAN_PROFILE_CONFIG_DIR_NAME="config"
THE_PLAN_PROFILE_CONFIG_DIR_PATH="${THE_PLAN_PROFILE_DIR_PATH}/${THE_PLAN_PROFILE_CONFIG_DIR_NAME}"

THE_PLAN_PROFILE_ROOTFS_DIR_NAME="includes.chroot"
THE_PLAN_PROFILE_ROOTFS_DIR_PATH="${THE_PLAN_PROFILE_CONFIG_DIR_PATH}/${THE_PLAN_PROFILE_ROOTFS_DIR_NAME}"

THE_PLAN_PROFILE_BOOTLOADERS_DIR_NAME="bootloaders"
THE_PLAN_PROFILE_BOOTLOADERS_DIR_PATH="${THE_PLAN_PROFILE_CONFIG_DIR_PATH}/${THE_PLAN_PROFILE_BOOTLOADERS_DIR_NAME}"

THE_PLAN_PROFILE_HOOKS_DIR_NAME="hooks"
THE_PLAN_PROFILE_HOOKS_DIR_PATH="${THE_PLAN_PROFILE_CONFIG_DIR_PATH}/${THE_PLAN_PROFILE_HOOKS_DIR_NAME}"

THE_PLAN_PROFILE_PACKAGES_DIR_NAME="package-lists"
THE_PLAN_PROFILE_PACKAGES_DIR_PATH="${THE_PLAN_PROFILE_CONFIG_DIR_PATH}/${THE_PLAN_PROFILE_PACKAGES_DIR_NAME}"




THE_PLAN_ASSET_DIR_NAME="asset"
THE_PLAN_ASSET_DIR_PATH="${THE_PLAN_DIR_PATH}/${THE_PLAN_ASSET_DIR_NAME}"

THE_PLAN_OVERLAY_DIR_NAME="overlay"
THE_PLAN_OVERLAY_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_OVERLAY_DIR_NAME}"

THE_PLAN_BOOT_DIR_NAME="boot"
THE_PLAN_BOOT_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_BOOT_DIR_NAME}"

THE_PLAN_HOOK_DIR_NAME="hook"
THE_PLAN_HOOK_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_HOOK_DIR_NAME}"

THE_PLAN_INSTALLER_DIR_NAME="installer"
THE_PLAN_INSTALLER_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_INSTALLER_DIR_NAME}"

THE_PLAN_BUILD_DIR_NAME="build"
THE_PLAN_BUILD_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_BUILD_DIR_NAME}"

THE_PLAN_PACKAGE_DIR_NAME="package"
THE_PLAN_PACKAGE_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_PACKAGE_DIR_NAME}"

THE_PLAN_PACKAGE_BUNDLE_DIR_NAME="bundle"
THE_PLAN_PACKAGE_BUNDLE_DIR_PATH="${THE_PLAN_PACKAGE_DIR_PATH}/${THE_PLAN_PACKAGE_BUNDLE_DIR_NAME}"



THE_PLAN_CONFIG_DIR_NAME="config"
THE_PLAN_CONFIG_DIR_PATH="${THE_PLAN_ASSET_DIR_PATH}/${THE_PLAN_CONFIG_DIR_NAME}"

THE_PLAN_CONFIG_MAIN_DIR_NAME="main"
THE_PLAN_CONFIG_MAIN_DIR_PATH="${THE_PLAN_CONFIG_DIR_PATH}/${THE_PLAN_CONFIG_MAIN_DIR_NAME}"




THE_PLAN_HELPER_DIR_NAME="helper"
THE_PLAN_HELPER_DIR_PATH="${THE_PLAN_DIR_PATH}/${THE_PLAN_HELPER_DIR_NAME}"


THE_PLAN_DISTRO_DIR_NAME="distro"
THE_PLAN_DISTRO_DIR_PATH="${THE_PLAN_HELPER_DIR_PATH}/${THE_PLAN_DISTRO_DIR_NAME}"



##
### Tail: Path
################################################################################


################################################################################
### Head: Config
##

sys_config_main_user_name () {
	cat "$THE_PLAN_CONFIG_MAIN_DIR_PATH/main-user-name.conf"
}

sys_config_main_user_password () {
	cat "$THE_PLAN_CONFIG_MAIN_DIR_PATH/main-user-password.conf"
}

sys_config_root_user_password () {
	cat "$THE_PLAN_CONFIG_MAIN_DIR_PATH/root-user-password.conf"
}

##
### Tail: Config
################################################################################


################################################################################
### Head: Option
##

THE_DEFAULT_DISTRO="${THE_DEFAULT_DISTRO:=main-xfce}"

sys_default_distro () {
	echo "${THE_DEFAULT_DISTRO}"
}


THE_DEFAULT_RUN="${THE_DEFAULT_RUN:=make-iso}"

sys_default_run () {
	echo "${THE_DEFAULT_RUN}"
}

##
### Tail: Option
################################################################################



################################################################################
### Head: Util / Debug
##

util_error_echo () {
	echo "$@" 1>&2
}

##
### Head: Util / Debug
################################################################################


################################################################################
### Head: Signal
##

exit_on_signal_interrupted () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## **Script Interrupted**"
	util_error_echo "##"
	util_error_echo

	sys_clean_on_exit

	sleep 2

	exit 0

}

exit_on_signal_terminated () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## **Script Terminated**"
	util_error_echo "##"
	util_error_echo

	sys_clean_on_exit

	sleep 2

	exit 0

}

sys_signal_bind () {

	trap exit_on_signal_interrupted SIGINT
	trap exit_on_signal_terminated SIGTERM

}

##
### Tail: Signal
################################################################################


################################################################################
### Head: Limit Run User
##

sys_root_user_required () {

	if [[ "${EUID}" = 0 ]]; then
		return 0
	else
		util_error_echo "Please Run As Root"
		#sleep 2
		exit 0
	fi

}

##
### Tail: Limit Run User
################################################################################


################################################################################
### Head: Clean
##

sys_clean_on_prepare () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Cleaning Data On Prepare"
	util_error_echo "##"
	util_error_echo


	util_error_echo
	util_error_echo "rm -rf ${THE_PLAN_TMP_DIR_PATH}"
	rm -rf "${THE_PLAN_TMP_DIR_PATH}"


	util_error_echo

}

sys_clean_on_exit () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Cleaning Data On Exit"
	util_error_echo "##"
	util_error_echo



}

sys_clean_on_finish () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Cleaning Data On Finish"
	util_error_echo "##"
	util_error_echo


}

##
### Tail: Clean
################################################################################


################################################################################
### Head: Requirements
##

sys_package_required () {

	return 0

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Check Package Required"
	util_error_echo "##"
	util_error_echo


	util_error_echo
	util_error_echo "sudo apt-get install live-build"
	util_error_echo
	sudo apt-get install live-build


	util_error_echo



}

##
### Tail: Requirements
################################################################################



################################################################################
### Head: Model / Build ISO
##

mod_iso_make_prepare () {

	sys_package_required

	sys_clean_on_prepare

	mod_iso_profile_prepare

}


mod_iso_make_start () {

	local to_run="to_$(sys_default_run)"

	if [ "${to_run}" != "to_make-iso" ]; then
		return
	fi

	mod_iso_make_start_create_iso

}

mod_iso_make_start_create_iso () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Building New ISO"
	util_error_echo "##"
	util_error_echo

	#sleep 5
	#return 0

	util_error_echo
	util_error_echo "cd ${THE_PLAN_PROFILE_DIR_PATH}"
	cd "${THE_PLAN_PROFILE_DIR_PATH}"


	util_error_echo
	util_error_echo "lb build"
	lb build


	util_error_echo
	util_error_echo "cd ${OLDPWD}"
	cd "${OLDPWD}"


	util_error_echo
	util_error_echo


}

mod_iso_make_finish () {

	mod_iso_make_copy_to_store

	sys_clean_on_finish

}

mod_iso_make_copy_to_store () {

	local iso_store_dir_path="../../../../iso/"

	if ! [ -d "${iso_store_dir_path}" ]; then
		return
	fi

	cp -a out/*.iso "${iso_store_dir_path}/"
}

mod_iso_build () {

	mod_iso_make_prepare
	mod_iso_make_start
	mod_iso_make_finish

}

##
### Tail: Model / Build ISO
################################################################################




################################################################################
### Head: Model / Build ISO / Base Profile
##

mod_iso_profile_prepare () {

	util_error_echo
	util_error_echo "##"
	util_error_echo "## Prepare ISO Profile"
	util_error_echo "##"
	util_error_echo

	mod_iso_profile_base
	mod_iso_profile_overlay


}

mod_iso_profile_base () {

	util_error_echo
	util_error_echo
	util_error_echo "##"
	util_error_echo "## Prepare ISO Profile / Base"
	util_error_echo "##"
	util_error_echo


	util_error_echo
	util_error_echo "mkdir -p ${THE_PLAN_PROFILE_DIR_PATH}"
	mkdir -p "${THE_PLAN_PROFILE_DIR_PATH}"



	util_error_echo
	util_error_echo "cd ${THE_PLAN_PROFILE_DIR_PATH}"
	cd "${THE_PLAN_PROFILE_DIR_PATH}"

	local distro_name="eznixos-xfce"

	lb config \
		--binary-images iso-hybrid \
		--mode debian \
		--architectures amd64 \
		--linux-flavours amd64 \
		--distribution bookworm \
		--archive-areas "main contrib non-free non-free-firmware" \
		--updates true \
		--security true \
		--cache true \
		--apt-recommends true \
		--firmware-binary true \
		--firmware-chroot true \
		--win32-loader false \
		--iso-application "${distro_name}" \
		--iso-preparer eznix-https://sourceforge.net/projects/eznixos/ \
		--iso-publisher eznix-https://sourceforge.net/projects/eznixos/ \
		--image-name "${distro_name}-$(date -u +"%y%m%d")" \
		--iso-volume "${distro_name}-$(date -u +"%y%m%d")" \
		--checksums sha512 \
		--clean \
		--color



	util_error_echo
	util_error_echo "cd ${OLDPWD}"
	cd "${OLDPWD}"



	util_error_echo
}

##
### Tail: Model / Build ISO / Base Profile
################################################################################


################################################################################
### Head: Model / Build ISO / Overlay Profile
##

mod_iso_profile_overlay () {

	util_error_echo
	util_error_echo
	util_error_echo "##"
	util_error_echo "## Prepare ISO Profile / Overlay"
	util_error_echo "##"
	util_error_echo


	##
	## ## base
	##

	mod_overlay_base


	##
	## ## bootloader
	##

	mod_overlay_bootloader


	##
	## ## hook
	##

	mod_overlay_hook


	##
	## ## installer
	##

	mod_overlay_installer


	##
	## ## package
	##

	mod_overlay_package


	return 0


	##
	## ## lsb-release
	##

	mod_overlay_lsb_release


	##
	## ## profiledef
	##

	mod_overlay_profiledef


	##
	## ## permission
	##

	mod_overlay_permission


	##
	## ## locale
	##

	mod_overlay_locale


	##
	## ## systemd
	##

	mod_overlay_systemd


}


##
### Tail: Model / Build ISO / Overlay Profile
################################################################################


################################################################################
### Head: Model / Overlay / base
##

mod_overlay_base () {

	#mod_overlay_pre_remove
	mod_overlay_by_dir

}

##
### Tail: Model / Overlay / base
################################################################################


################################################################################
### Head: Model / Overlay / by_dir
##

mod_overlay_by_dir () {

	util_error_echo
	util_error_echo "cp -rf ${THE_PLAN_OVERLAY_DIR_PATH}/. ${THE_PLAN_PROFILE_ROOTFS_DIR_PATH}"
	cp -rf "${THE_PLAN_OVERLAY_DIR_PATH}/." "${THE_PLAN_PROFILE_ROOTFS_DIR_PATH}"

}

##
### Tail: Model / Overlay / by_dir
################################################################################



################################################################################
### Head: Model / Overlay / boot loader
##

mod_overlay_bootloader () {

	util_error_echo
	util_error_echo "cp -rf ${THE_PLAN_BOOT_DIR_PATH}/. ${THE_PLAN_PROFILE_BOOTLOADERS_DIR_PATH}"
	cp -rf "${THE_PLAN_BOOT_DIR_PATH}/." "${THE_PLAN_PROFILE_BOOTLOADERS_DIR_PATH}"

}


##
### Tail: Model / Overlay / boot loader
################################################################################




################################################################################
### Head: Model / Overlay / hook
##

mod_overlay_hook () {

	mod_overlay_hook_pre_remove
	mod_overlay_hook_normal

}

mod_overlay_hook_pre_remove () {

	util_error_echo
	util_error_echo "rm -f ${THE_PLAN_PROFILE_HOOKS_DIR_PATH}/normal/9000-remove-gnome-icon-cache.hook.chroot"
	rm -f "${THE_PLAN_PROFILE_HOOKS_DIR_PATH}/normal/9000-remove-gnome-icon-cache.hook.chroot"

}

mod_overlay_hook_normal () {

	util_error_echo
	util_error_echo "cp -rf ${THE_PLAN_HOOK_DIR_PATH}/. ${THE_PLAN_PROFILE_HOOKS_DIR_PATH}/normal"
	cp -rf "${THE_PLAN_HOOK_DIR_PATH}/." "${THE_PLAN_PROFILE_HOOKS_DIR_PATH}/normal"

}

##
### Tail: Model / Overlay / hook
################################################################################




################################################################################
### Head: Model / Overlay / installer
##

mod_overlay_installer () {

	mod_overlay_installer_calamares

}

mod_overlay_installer_calamares () {

	util_error_echo
	util_error_echo "cp -rf ${THE_PLAN_INSTALLER_DIR_PATH}/calamares/. ${THE_PLAN_PROFILE_ROOTFS_DIR_PATH}/etc/calamares"
	cp -rf "${THE_PLAN_INSTALLER_DIR_PATH}/calamares/." "${THE_PLAN_PROFILE_ROOTFS_DIR_PATH}/etc/calamares"

}

##
### Tail: Model / Overlay / hook
################################################################################




################################################################################
### Head: Model / Overlay / package
##

mod_overlay_package () {

	mod_overlay_package_list

}

mod_overlay_package_list () {

	util_error_echo
	util_error_echo "cp -rf ${THE_PLAN_PACKAGE_DIR_PATH}/xfce/. ${THE_PLAN_PROFILE_PACKAGES_DIR_PATH}"
	cp -rf "${THE_PLAN_PACKAGE_DIR_PATH}/xfce/." "${THE_PLAN_PROFILE_PACKAGES_DIR_PATH}"

}

##
### Tail: Model / Overlay / hook
################################################################################


################################################################################
### Head: Main
##

__main__ () {

	sys_root_user_required
	sys_signal_bind
	mod_iso_build

}

__main__

##
### Tail: Main
################################################################################

