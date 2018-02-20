# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils desktop

DESCRIPTION="Open Source 2D CAD"
HOMEPAGE="http://www.qcad.org/"
SRC_URI="
qt5? ( http://www.ribbonsoft.com/archives/qcad/${P/-bin/}-trial-linux-x86_64.tar.gz )
qt4? ( http://www.ribbonsoft.com/archives/qcad/${P/-bin/}-trial-linux-qt4-x86_64.tar.gz )
"
#EGIT_REPO_URI="https://github.com/qcad/qcad.git"
#EGIT_COMMIT="v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

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
"
RDEPEND="${DEPEND} !media-gfx/qcad"
S="${WORKDIR}"/${P/-bin/}-trial-linux-x86_64

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
	doicon ${S}/scripts/${PN/-bin/}_icon.svg
	doicon --size 256 ${S}/scripts/${PN/-bin/}_icon.png
	make_desktop_entry "${PN}" "QCAD Professional" "${PN/-bin/}_icon" "Engineering"

	insinto /usr/libexec/${PN}
	doins adinit.dat

    doins -r fonts libraries linetypes patterns scripts themes ts xcbglintegrations
    insopts -m0755
    #doins release/*
	make_wrapper ${PN} /usr/libexec/${PN}/qcad-bin "" /usr/libexec/${PN}:/usr/libexec/${PN}/plugins
    doins -r plugins
	doins qcad*
	doins *.so*
	doins -r platforms platforminputcontexts 
	doins merge
	doins dwg*
	doins bbox

    docinto examples
    dodoc -r examples/*
    docompress -x /usr/share/doc/${PF}/examples
	dodoc revision.txt

}
