# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils git-r3

DESCRIPTION="ACID scripts for CMaNGOS Three and Cataclysm (CATA) 4.3.4 client"
HOMEPAGE="http://www.scriptdev2.com/forums/6-ACID-Development"
LICENSE="GPL-2+"
SLOT="3"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=virtual/mysql-5.1.0
"
IUSE=""
S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/ACID-Scripts/CATA.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="4e55721e8765a108b0f8d3923da0f22969a1176a"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/acid/${SLOT}"
	cp -R "${WORKDIR}"/* "${D}/usr/share/acid/${SLOT}"
}

pkg_config() {
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s

	mysql --user="${USERNAME}" --password="${REPLY}" ${PREFIX}_mangos < ${ROOT}/usr/share/acid/${SLOT}/acid_cata.sql

	einfo "ACID committed changes."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} to update acid."
	einfo ""
}
