# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The API tools serve as the client interface to the Auto Scaling web service"
HOMEPAGE="http://aws.amazon.com/developertools/2535"
# SRC_URI="http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip"
SRC_URI="mirror://sabayon/app-admin/AutoScaling-1.0.49.1.zip"

LICENSE="Amazon"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="app-arch/unzip"
RDEPEND="virtual/jre"

S="${WORKDIR}/AutoScaling-${PV}"

src_prepare() {
	default

	find . -name '*.cmd' -delete || die
	rm bin/{as-cmd,service}-2009-05-15 || die
}

src_install() {
	insinto /opt/${PN}/lib
	doins -r lib/.

	exeinto /opt/${PN}/bin
	doexe bin/*

	cat > "${T}"/99${PN} <<- EOF || die
		AWS_AUTO_SCALING_HOME=/opt/${PN}
		PATH=/opt/${PN}/bin
		ROOTPATH=/opt/${PN}/bin
	EOF
	doenvd "${T}"/99${PN}

	dodoc "THIRDPARTYLICENSE.TXT"
}

pkg_postinst() {
	ewarn "Remember to run: env-update && source /etc/profile if you plan"
	ewarn "to use these tools in a shell before logging out (or restarting"
	ewarn "your login manager)"

	elog
	elog "You need to put the following in your ~/.bashrc replacing the"
	elog "values with the full path to your AWS credentials file."
	elog
	elog "  export AWS_CREDENTIAL_FILE=/path/and_filename_of_credential_file"
	elog
	elog "It should contains two lines: the first line lists the AWS Account's"
	elog "AWS Access Key ID, and the second line lists the AWS Account's"
	elog "Secret Access Key. For example:"
	elog
	elog "  AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE"
	elog "  AWSSecretKey=wJalrXUtnFEMI/K7MDENG/bPxRfiCYzEXAMPLEKEY"
}
