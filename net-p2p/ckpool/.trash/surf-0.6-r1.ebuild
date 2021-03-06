#for testing webkit-gtk-2.0.4
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/surf/surf-0.6-r1.ebuild,v 1.7 2013/11/01 13:50:07 ago Exp $

EAPI=6
inherit autotools eutils flag-o-matic multilib savedconfig toolchain-funcs

DESCRIPTION="A simple web browser based on WebKit/GTK+."
HOMEPAGE="http://surf.suckless.org/"
SRC_URI="http://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="MIT CC-BY-NA-SA-3.0 SURF-community"
SLOT="0"
KEYWORDS="gnu32 gnu64 muslx32"

IUSE="gtk3 adblock gnu32 gnu64 muslx32"

#                >=net-libs/webkit-gtk-1.1.15:2
COMMON_DEPEND="
	dev-libs/glib
	net-libs/libsoup
	x11-libs/libX11
       !gtk3? (
                =net-libs/webkit-gtk-2.0.4-r200
                >=x11-libs/gtk+-2.14:2
        )
        gtk3? (
                =net-libs/webkit-gtk-2.0.4
                x11-libs/gtk+:3
        )
	sys-apps/dbus[X]
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="
	!sci-chemistry/surf
	${COMMON_DEPEND}
	x11-apps/xprop
	x11-misc/dmenu
        net-misc/curl
        x11-terms/st
	dev-libs/json-glib
"
USE_REQUIRED="savedconfig gtk3 adblock"

pkg_setup() {
	if use savedconfig; then
		if [[ ! -f "/etc/portage/savedconfig/${CATEGORY}/${PN}-${PVR}" ]]; then
			elog "Please copy ${FILESDIR}/${PN}-${PVR} to /etc/portage/savedconfig/${CATEGORY}/ and edit accordingly."
			die ""
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${PN}-search.patch
	if use gtk3 ; then
		epatch "${FILESDIR}"/${PN}-gtk3.patch
		epatch "${FILESDIR}"/${PN}-gtk3fix1.patch
		epatch "${FILESDIR}"/${PN}-gtk3fix2.patch
		epatch "${FILESDIR}"/${PN}-gtk3fix3.patch
		epatch "${FILESDIR}"/${PN}-gtk3fix4.patch
	fi
	#if use ssl_proxy ; then
	#	epatch "${FILESDIR}"/${PN}-sslproxy.patch
	#fi
	if use adblock ; then
		epatch "${FILESDIR}"/${PN}-adblock.patch
		epatch "${FILESDIR}"/${PN}-adblock1.patch
	fi
	if use gtk3 ; then
		epatch "${FILESDIR}"/${PN}-webkit2gtk1.patch
		epatch "${FILESDIR}"/${PN}-webkit2gtk2.patch
		epatch "${FILESDIR}"/${PN}-webkit2gtk3.patch
		epatch "${FILESDIR}"/${PN}-webkit2gtk4.patch
		epatch "${FILESDIR}"/${PN}-webkit2gtk5.patch
		epatch "${FILESDIR}"/${PN}-webkit2gtk6.patch
	fi

	#epatch "${FILESDIR}"/${PN}-adblockext.patch #this disables the adblock extension
	if use adblock ; then
		epatch "${FILESDIR}"/${PN}-0.6-adblock-debugtimer.patch
	fi

	epatch_user
	restore_config config.h
	tc-export CC PKG_CONFIG

	cd "${WORKDIR}/${P}"
	cat "${FILESDIR}"/configure.ac > configure.ac
	cat "${FILESDIR}"/Makefile.am > Makefile.am
	touch NEWS AUTHORS ChangeLog

	epatch "${FILESDIR}"/surf-0.6-copyrights.patch
	epatch "${FILESDIR}"/surf-0.6-copyright-2.patch

	[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-1.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-2.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-3.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-4.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-5.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-6.patch
	#[[ "${CHOST}" =~ "muslx32" ]] && epatch "${FILESDIR}"/${PN}-0.6-webkit-2.0.4-7.patch
	#epatch "${FILESDIR}"/surf-0.6-hide-bg.patch

	epatch "${FILESDIR}"/surf-0.6-gtk2-1.patch
	epatch "${FILESDIR}"/surf-0.6-gtk2-2.patch
	epatch "${FILESDIR}"/surf-0.6-gtk2-3.patch
	epatch "${FILESDIR}"/surf-0.6-gtk2-4.patch
	epatch "${FILESDIR}"/surf-0.6-gtk2-5.patch

	eautoreconf
}

src_configure() {
	local myconf
	  if use gnu32 ; then
		CONF_LIBDIR_OVERRIDE="lib32"
		append-cflags "-m32"
		append-cxxflags "-m32"
		append-ldflags "-m32"
		case ${CHOST} in
			*-gnu)
				myconf+=( --target=i686-pc-linux-gnu )
				myconf+=( --host=i686-pc-linux-gnu )
				myconf+=( --libdir=/usr/lib32 )
				append-ldflags -L/usr/lib32
				;;
			*)
				;;
		esac
	elif use gnu64 ; then
		CONF_LIBDIR_OVERRIDE="lib64"
		append-cflags "-m64"
		append-cxxflags "-m64"
		append-ldflags "-m64"
		case ${CHOST} in
			*-gnu)
				myconf+=( --target=x86_64-pc-linux-gnu )
				myconf+=( --host=x86_64-pc-linux-gnu )
				myconf+=( --libdir=/usr/lib64 )
				append-ldflags -L/usr/lib64
				;;
			*)
				;;
		esac
	elif use muslx32 ; then
		CONF_LIBDIR_OVERRIDE="lib"
		append-cflags "-mx32"
		append-cxxflags "-mx32"
		append-ldflags "-mx32"
		case ${CHOST} in
			*-muslx32)
				myconf+=( --target=x86_64-pc-linux-muslx32 )
				myconf+=( --host=x86_64-pc-linux-muslx32 )
				myconf+=( --libdir=/usr/lib )
				append-ldflags -L/usr/lib
				;;
			*)
				;;
		esac
	else
		append-ldflags -L/usr/$(get_libdir)
	fi

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

src_compile() {
	if use gnu32 ; then
		CONF_LIBDIR_OVERRIDE="lib32"
	elif use gnu64 ; then
		CONF_LIBDIR_OVERRIDE="lib64"
	elif use muslx32 ; then
		CONF_LIBDIR_OVERRIDE="lib"
	else
		true
	fi
	emake
}

src_install() {
	if use gnu32 ; then
		CONF_LIBDIR_OVERRIDE="lib32"
	elif use gnu64 ; then
		CONF_LIBDIR_OVERRIDE="lib64"
	elif use muslx32 ; then
		CONF_LIBDIR_OVERRIDE="lib"
	else
		true
	fi
	default
	save_config config.h

	if use adblock ; then
		mkdir -p "${D}/etc/surf/scripts"
		cp -r "${FILESDIR}/events" "${D}/etc/surf/scripts/"
		cp -r "${FILESDIR}/adblock" "${D}/etc/surf/scripts/"
	fi

	mkdir -p "${D}/usr/share/surf"
	cp "${FILESDIR}"/rip* "${D}/usr/share/surf"
	cp "${FILESDIR}"/mimehandler "${D}/usr/share/surf"
	cp "${FILESDIR}"/script.js "${D}/usr/share/surf"
	cp "${FILESDIR}"/style.css "${D}/usr/share/surf"
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 0.4.1-r1 ]]; then
		ewarn "Please correct the permissions of your \$HOME/.surf/ directory"
		ewarn "and its contents to no longer be world readable (see bug #404983)"
	fi
	elog "If you want external media support cp /usr/share/${PN}/rip* to your home directory."
	elog "If you want mime support cp /usr/share/${PN}/mimehandler to your home directory."
	elog "If you want link hinting support cp /usr/share/${PN}/\{script.js,style.css\} to your home/.surf directory."
	elog "You must update the adblock filters manually at /etc/surf/adblock/update.sh."
}
