# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="2D CAD application"
HOMEPAGE="http://www.qcad.org/"

RESTRICT="mirror"

SRC_URI="https://github.com/qcad/qcad/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

L10N=( de en es fr it ja nl pl pt ru sl sk sv fi hr hu zh_CN cs TW lt )

IUSE="qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

for lingua in ${L10N[*]}; do
    IUSE+=" l10n_${lingua}"
done

DEPEND="
    dev-libs/glib
	media-libs/glu
	media-libs/mesa
	qt5? (
		dev-qt/designer:5
		>=dev-qt/qtcore-5.8.0
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtopengl:5
		dev-qt/qtscript:5[scripttools]
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwebkit:5
		dev-qt/qtxmlpatterns:5
		dev-qt/qtwebengine:5
	)
	qt4? (
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qthelp:4
		dev-qt/qtopengl:4
		dev-qt/qtscript:4
		dev-qt/qtsql:4
		dev-qt/qtsvg:4
		dev-qt/qtwebkit:4
		dev-qt/qtxmlpatterns:4
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "$S"
	sed -i -s -r 's,system\(cp ".*libqlinuxfb.so".*,,' src/run/run.pri
	default_src_prepare;
}

src_configure () {
	if use qt4; then
		eqmake4 -r || die
	elif use qt5; then
		eqmake5 -r || die
	fi
}

src_install () {
    cd "${S}"
    for lingua in "${L10N[@]}"
    do
        if ! use l10n_${lingua}
        then
            find -type f -name "*_${lingua}.*" -delete
        fi
    done

    dobin ${FILESDIR}/qcad

    insinto /usr/lib/${PN}/
    doins -r scripts fonts patterns
    insopts -m0755
    doins release/*
    doins -r plugins

    docinto examples
    dodoc examples/*
    docompress -x /usr/share/doc/${PF}/examples

}
