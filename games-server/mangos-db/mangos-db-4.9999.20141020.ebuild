# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="MaNGOS Four database for the Mists of Pandaria (MOP) 5.4.8 Client"
HOMEPAGE="https://www.getmangos.eu/"
LICENSE="CC-BY-NC-SA-3.0"
SLOT="4"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-libs/boost-1.49
	>=virtual/mysql-5.1.0
	>=dev-util/cmake-2.8.9
	>=dev-libs/openssl-1.0
	>=sys-devel/gcc-4.7.2
	>=sys-libs/zlib-1.2.7
	>=net-libs/zeromq-2.2.6
	app-arch/bzip2
"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	EGIT_CHECKOUT_DIR="${WORKDIR}"
	EGIT_REPO_URI="https://github.com/mangosfour/database.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="2cdc01756ab7525043e6ddfbe0254dda6693f440"
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	epatch_user
}

src_install() {
	mkdir -p "${D}/usr/share/mangos/${SLOT}"
	cp -R "${WORKDIR}"/* "${D}/usr/share/mangos/${SLOT}"
	cp "${FILESDIR}/install-mangos-db.sh" "${D}/usr/share/mangos/${SLOT}"
	fperms 0755 "/usr/share/mangos/${SLOT}/install-mangos-db.sh"
}

pkg_config() {
	einfo "Enter type of database operation (new, safe_update, unsafe_update):"
	read TYPE
	einfo "Enter server type (mangos, cmangos):"
	read ENGINE
	einfo "Enter the mangos db prefix:"
	read PREFIX
	einfo "Enter the mysql admin username:"
	read USERNAME
	einfo "Enter the mysql admin password:"
	read -s
	${ROOT}/usr/share/mangos/${SLOT}/install-mangos-db.sh $PREFIX $USERNAME $REPLY "$ENGINE" "${SLOT}" "$TYPE"
	einfo "Your mysql databases are ${PREFIX}_characters, ${PREFIX}_realmd, and ${PREFIX}_mangos."
	unset REPLY
}

pkg_postinst() {
	einfo ""
	einfo "Use emerge --config =${P} for new install or update."
	einfo ""
}