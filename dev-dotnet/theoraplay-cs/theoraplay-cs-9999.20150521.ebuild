# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="TheoraPlay# is a C# wrapper for Theora Play"
HOMEPAGE=""
PROJECT_NAME="TheoraPlay-CS"
COMMIT="d5bae691e56d0a4b7334206d6b92b4ff3cb2cd04"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         media-libs/theoraplay"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/Release/TheoraPlay-CS.dll.mdb
	fi

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins bin/Release/TheoraPlay-CS.dll.config

	dotnet_multilib_comply
}
