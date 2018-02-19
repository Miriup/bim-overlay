# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="OpenCascade Community Edition"
HOMEPAGE="https://github.com/tpaviot/oce"
SRC_URI="https://github.com/tpaviot/${PN}/archive/OCE-${PV}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-eselect/eselect-opencascade"

CHECKREQS_MEMORY="256M"
CHECKREQS_DISK_BUILD="3584M"

RDEPEND="${DEPEND}"
S="${WORKDIR}"/"${PN}-OCE-${PV}"

src_configure() {
	#CASROOT=/usr/lib64/opencascade-6.9.1/ros/lin
	local mycmakeargs=(
		-DOCE_INSTALL_PREFIX:PATH=/usr
		-DLIBDIR=$(get_libdir)
		)

	cmake-utils_src_configure
}
