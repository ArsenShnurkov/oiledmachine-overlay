# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="TiledSharp is a C# map loader for Tiled Map Editor maps."
HOMEPAGE=""
COMMIT="b4f95996b2437b7330fb2b39449278e8b1ef04f1"
PROJECT_NAME="TiledSharp"
SRC_URI="https://github.com/marshallward/TiledSharp/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac ${PACKAGE_FEATURES} doc"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
        doc? ( app-doc/doxygen )
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        einfo "Building solutions"
        exbuild_strong ${PROJECT_NAME}.sln || die

	if use doc ; then
		cd docs
		doxygen Doxyfile
	fi
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	esavekey

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/TiledSharp/bin/${mydebug}/TiledSharp.dll"
        done
	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins TiledSharp/bin/${mydebug}/TiledSharp.dll.mdb
	fi

	use doc && dodoc -r docs/html

	dotnet_multilib_comply
}
