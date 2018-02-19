# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils #git-r3

DESCRIPTION="Open Source 2D CAD"
HOMEPAGE="http://www.qcad.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
#EGIT_REPO_URI="https://github.com/qcad/qcad.git"
#EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
		>=dev-qt/designer-5.8.0
		>=dev-qt/qtcore-5.8.0
		>=dev-qt/qtgui-5.8.0
		>=dev-qt/qthelp-5.8.0
		>=dev-qt/qtopengl-5.8.0
		>=dev-qt/qtscript-5.8.0[scripttools]
		>=dev-qt/qtsql-5.8.0
		>=dev-qt/qtsvg-5.8.0
		>=dev-qt/qtwebkit-5.8.0
		>=dev-qt/qtxmlpatterns-5.8.0
		>=dev-qt/qtwebengine-5.8.0
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
	if ! test -d ${S}/src/3rdparty/qt-labs-qtscriptgenerator-5.9.
	then
		einfo Creating QT configuration for QT 5.9.2
		mkdir ${S}/src/3rdparty/qt-labs-qtscriptgenerator-5.9.2
		ln ${S}/src/3rdparty/qt-labs-qtscriptgenerator-5.9.1/qt-labs-qtscriptgenerator-5.9.1.pro ${S}/src/3rdparty/qt-labs-qtscriptgenerator-5.9.2/qt-labs-qtscriptgenerator-5.9.2.pro
	fi

	default
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

    #dobin ${FILESDIR}/qcad
	#test -e ${S}/release/${PN} || ln ${S}/release/qcad-bin ${S}/release/${PN}
	#dobin ${S}/release/${PN}
	domenu ${S}/*.desktop
	doicon ${S}/scripts/${PN}_icon.svg
	doicon --size 256 ${S}/scripts/${PN}_icon.png

    insinto /usr/lib/${PN}/
    doins -r scripts fonts patterns
    insopts -m0755
    doins release/*
	make_wrapper ${PN} /usr/lib/${PN}/qcad-bin "" /usr/lib/${PN}:/usr/lib/${PN}/plugins
    doins -r plugins

    docinto examples
    dodoc -r examples/*
    docompress -x /usr/share/doc/${PF}/examples

}
