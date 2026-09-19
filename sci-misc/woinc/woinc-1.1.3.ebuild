# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="woinc - an alternative to boinccmd and boincmgr"
HOMEPAGE="https://github.com/vmc-coding/woinc"
SRC_URI="https://github.com/vmc-coding/woinc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cli extra minimal qt5 qt6 test"
REQUIRED_USE="?? ( qt5 qt6 )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/pugixml
	qt5? (
		dev-qt/qtcharts:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
	)
	qt6? (
		dev-qt/qtbase:6[network]
		dev-qt/qtcharts:6
	)
"
DEPEND="
	${RDEPEND}
	test? (
		qt5? ( dev-qt/qttest:5 )
	)
"

src_configure() {
	local mycmakeargs=(
		-DWOINC_BUILD_UI_CLI=$(usex cli)
		-DWOINC_BUILD_UI_QT=$(usex qt6 yes $(usex qt5))
		-DWOINC_EXPOSE_FULL_STRUCTURES=$(usex !minimal)
		-DWOINC_CLI_COMMANDS=$(usex extra)
		$(cmake_use_find_package qt5 Qt5)
		$(cmake_use_find_package qt6 Qt6)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && cmake_build tests
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}
