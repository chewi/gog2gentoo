# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependencies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=5500M

inherit gog-games

DESCRIPTION="Amnesia: A Machine For Pigs"
HOMEPAGE="https://www.gog.com/game/amnesia_a_machine_for_pigs"

SRC_URI="gog_amnesia_a_machine_for_pigs_2.0.0.2.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/devil
				media-libs/libsdl2
				media-libs/openal
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/libogg )"

DEPEND=""

gog_pn="amnesia_a_machine_for_pigs"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	chmod 0750 AmnesiaAMFP.bin.x86 Launcher.bin.x86 AmnesiaAMFP.bin.x86_64 Launcher.bin.x86_64

	use amd64 || rm AmnesiaAMFP.bin.x86_64 Launcher.bin.x86_64 || die
	use x86 || rm AmnesiaAMFP.bin.x86 Launcher.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/AmnesiaAMFP.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./Launcher.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./Launcher.bin.x86 "${dir}"
	newicon AmnesiaAMFP.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}