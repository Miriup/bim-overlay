# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="IfcOpenShell is an open source (LGPL) software library that helps users and software developers to work with the IFC file format."
HOMEPAGE="http://ifcopenshell.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="https://github.com/IfcOpenShell/IfcOpenShell.git"
EGIT_COMMIT="v${PVR/_pre/-preview}"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="collada ifc4 openconnect python unicode"

DEPEND="sci-libs/opencascade
dev-libs/boost
unicode? ( dev-libs/icu )
collada? ( media-libs/opencollada )
python? ( dev-lang/swig )"
RDEPEND="${DEPEND}"
CMAKE_USE_DIR="${S}/cmake"
CMAKE_MIN_VERSION="2.8.5"

src_configure() {
	default
}
src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with openconnect)
		$(cmake-utils_use unicode UNICODE_SUPPORT)
		$(cmake-utils_use python BUILD_IFCPYTHON)
		$(cmake-utils_use ifc4 USE_IFC4)
		$(cmake-utils_use collada COLLADA_SUPPORT)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_EXAMPLES=OFF
		-DOCC_INCLUDE_DIR=$CASROOT/inc
		-DOCC_LIBRARY_DIR=$CASROOT/lib
	)

	cmake-utils_src_configure
}
