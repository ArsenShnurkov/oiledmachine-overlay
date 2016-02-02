# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3

DESCRIPTION="LateralGM Plugin"
HOMEPAGE="https://github.com/enigma-dev/lgmplugin"
SRC_URI=""

RESTRICT="fetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/jre
	 dev-java/eclipse-ecj:4.4
	 dev-java/jna[nio-buffers]
	 games-misc/lateralgm
	 dev-java/icedtea
	 "
DEPEND="${RDEPEND}
	 "

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/enigma-dev/lgmplugin.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="9bfe9c0788c9ea13bcd304c41739932be231ba0b"
        git-r3_fetch
        git-r3_checkout
}

S="${WORKDIR}/lgmplugin-9999"

src_prepare() {
	sed -i -e "s|JC = ecj -1.6 -nowarn -cp .|JC = $(ls /usr/bin/ecj-4.4*) -1.7 -nowarn -cp .|" Makefile
	sed -i -e "s|../plugins/shared/jna.jar:../lgm16b4.jar:/usr/share/java/eclipse-ecj.jar:/usr/share/java/ecj.jar|/usr/share/jna/lib/jna.jar:/usr/$(get_libdir)/enigma/lateralgm.jar:/usr/share/eclipse-ecj-4.4/lib/ecj.jar|" Makefile
	sed -i -e "s|../plugins/enigma.jar|enigma.jar|" Makefile
	sed -i -e "s|        |\t|" Makefile
	sed -i -e "s|../lateralgm.jar shared/svnkit.jar shared/jna.jar|../lateralgm.jar /usr/$(get_libdir)/enigma/swinglayout-lgm.jar /usr/share/jna/lib/jna.jar|" META-INF/MANIFEST.MF
}

src_compile() {
	#icedtea is required because of missing classes
	MAKEOPTS="-j1" \
	make
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/enigma/plugins"
	cp enigma.jar "${D}/usr/$(get_libdir)/enigma/plugins"
}
