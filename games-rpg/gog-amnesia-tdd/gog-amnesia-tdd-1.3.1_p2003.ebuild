# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO:
# - find out all required use flags for dependicies
# - find out all licenses on which package depends

EAPI="5"

CHECKREQS_DISK_BUILD=2500M

inherit gog-games

DESCRIPTION="Amnesia: The Dark Descent"
HOMEPAGE="https://www.gog.com/game/amnesia_the_dark_descent"

SRC_URI="gog_amnesia_the_dark_descent_2.0.0.3.sh"

KEYWORDS="-* ~amd64 ~x86"
IUSE="bundled-libs"

RDEPEND="!bundled-libs? ( media-libs/devil
				media-libs/libsdl2
				media-libs/openal
				media-libs/libtheora
				media-libs/libvorbis
				media-libs/libogg )"

DEPEND=""

gog_pn="amnesia_the_dark_descent"

src_install() {
	if use bundled-libs; then
		use amd64 || rm -rf lib64 || die
		use x86 || rm -rf lib || die
	else
		rm -rf lib lib64 || die
	fi

	chmod 0750 Amnesia.bin.x86 Launcher.bin.x86 Amnesia.bin.x86_64 Launcher.bin.x86_64

	use amd64 || rm Amnesia.bin.x86_64 Launcher.bin.x86_64 || die
	use x86 || rm Amnesia.bin.x86 Launcher.bin.x86 || die

	# We do not use standart functions to save space and time
	mkdir -p "${D}${dir}" || die
	mv * "${D}${dir}" || die
	cp "${D}${dir}/Amnesia.png" . || die

	use amd64 && games_make_wrapper "${PN}" ./Launcher.bin.x86_64 "${dir}"
	use x86 && games_make_wrapper "${PN}" ./Launcher.bin.x86 "${dir}"
	newicon Amnesia.png "${PN}.png"
	make_desktop_entry "${PN}" "${DESCRIPTION}" ${PN}

	prepgamesdirs
}
