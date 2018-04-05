# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{3_5,3_6} )
PYTHON_REQ_USE="sqlite,xml"

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils gnome2-utils distutils-r1 versionator xdg-utils

MY_PV=${PV/_/-}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://www.gajim.org/"
SRC_URI="
	https://www.gajim.org/downloads/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
#	test? ( https://dev.gentoo.org/~jlec/distfiles/${PN}-tests-${PV}.tar.xz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="crypt dbus gnome gnome-keyring idle jingle libnotify networkmanager nls spell +srv test X xhtml zeroconf"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	libnotify? ( dbus )
	gnome? ( gnome-keyring )
	zeroconf? ( dbus )"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/pyasn1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.6.4[${PYTHON_USEDEP}]
	crypt? ( >=dev-python/python-gnupg-0.4.0[${PYTHON_USEDEP}] )
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-libs/dbus-glib
		zeroconf? ( net-dns/avahi[dbus,gtk,python,${PYTHON_USEDEP}] )
		)
	gnome? (
		dev-python/libgnome-python[${PYTHON_USEDEP}]
		dev-python/egg-python[${PYTHON_USEDEP}]
		)
	gnome-keyring? (
		dev-python/keyring[${PYTHON_USEDEP}]
		dev-python/secretstorage[${PYTHON_USEDEP}]
		)
	idle? ( x11-libs/libXScrnSaver )
	jingle? (
		net-libs/farstream[python,${PYTHON_USEDEP}]
		dev-python/gst-python:1.0[${PYTHON_USEDEP}]
		)
	networkmanager? (
			dev-python/dbus-python[${PYTHON_USEDEP}]
			net-misc/networkmanager
		)
	spell? ( app-text/gtkspell:3 )
	srv? (
		|| (
			dev-python/libasyncns-python[${PYTHON_USEDEP}]
			net-dns/bind-tools
			)
		)
	xhtml? ( dev-python/docutils[${PYTHON_USEDEP}] )"

RESTRICT="test"

S="${WORKDIR}"/${MY_P}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
