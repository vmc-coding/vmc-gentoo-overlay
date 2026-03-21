# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel Modules for TurboSight TBS 6281SE DVB-T/T2/C devices"
HOMEPAGE="https://www.tbsdtv.com/"
SRC_URI="https://www.tbsiptv.com/download/common/tbsdvb_v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/tbsdvb"

CONFIG_CHECK="VIDEOBUF2_DVB"

PATCHES=(
	"${FILESDIR}/build-needed-modules-only.patch"
)


src_compile() {
	local modlist=(
		dvb-core=::dvb-core
		gx1133=::frontends
		si2168=::frontends
		tas2101=::frontends
		tbsecp3=::pci/tbsecp3
		si2157=::tuners
	)
	local modargs=( KERNEL_BUILD="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
