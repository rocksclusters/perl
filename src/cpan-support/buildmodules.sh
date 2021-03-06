#!/bin/sh

# This script reads a file of CPAN module names (and options) to build and install
# Summary: 
#  buildmodules.sh modulefile
#
# RPM-versions of these modules. It uses cpantorpm.  The following modules must be 
# installed (through CPAN) for this to work the first time
# 	1. LWP::Simple
#	2. YAML
#	3. App::CPANtoRPM
#
#  The format of a line in the list of module files:
#   ModuleName  [rpmname] [{buildoption[:arg]}] [{buildoption[:arg]}] 
#	buildoption is any option understood by cpantorpm
#   
#   Examples:
#	YAML
#	LWP  libwww-perl
#       Text::Glob {--build-type:make}
#	 
cleanup()
{
	module unload opt-perl
}
sighandler()
{
	cleanup
	exit 0
}
module load opt-perl
trap 'sighandler' QUIT
trap 'sighandler' INT

if [ -z "${WORKDIR+x}" ]; then 
	WORKDIR=/tmp/rpm
fi
while read mod
do
	# Skip  comment lines in the module file
	echo $mod | grep -q '^#'
	if [ $? -eq 0 ]; then
		continue
	fi

	# Parse the line to figure out the module name and options
	read -r -a modinfo <<< $mod
	buildflags=""
	modperl=${modinfo[0]}
	rpmname=$(echo $modperl | sed 's/::/-/g')
	pkgfiles=""
	nelem=${#modinfo[@]}
	let nelem=${nelem}-1
	if [ ${nelem}  -gt 0 ]; then
		for i in `seq 1 ${nelem}`; do
			elem=${modinfo[$i]}
			echo $elem | grep -q '{'
			if [ $? -eq 0 ]; then
				bp=$(echo $elem | sed -e 's/{//' -e 's/}//' -e 's/:/ /')
				echo $bp | grep -q '%files'
				if [ $? -ne 0 ]; then
					buildflags="$buildflags $bp"
					echo ">> $buildflags"
				else
					echo -e "Setting pkgfiles to $bp"
					pkgfiles=$bp
				fi
			else
				rpmname=$elem
			fi
		done
	fi
	echo -e ">> $modperl $rpmname $buildflags $pkgfiles"

	## Create the SPEC file for this RPM. Try twice. It's perl, don't ask why
	retries=2
	for i in `seq 1 $retries`; do	
		/usr/bin/yes | /opt/perl/bin/cpantorpm  $buildflags --add-require "opt-perl" --install-base /opt/perl --prefix opt-perl- --packager Rocks --spec-only $modperl
		if [ $? -eq 0 ]; then break; fi
	done
	if [ $? -ne 0 ]; then code=$?; cleanup; exit $code; fi

	# Download the source tarball for this RPM
	(cd ${WORKDIR}/SOURCES; /opt/perl/bin/cpan -g $modperl)

	# Fix-up the  cpantorpm-generated spec file.
	SPECFILE=${WORKDIR}/SPECS/opt-perl-${rpmname}.spec
	/bin/sed -i -e "s#^%setup -T -D#%setup #" -e 's#perl/lib/perl5#perl/lib#g' $SPECFILE
	SPECFILETMP=$SPECFILE.$$
	awk -- '/Provides:[[:space:]]+perl/{print gensub("perl","opt-perl",1);next} /Requires:[[:space:]]+perl/{print gensub("perl","opt-perl",1);next} {print}' $SPECFILE > $SPECFILETMP
	awk -f remrequires $SPECFILETMP > $SPECFILE
	if [ $? -ne 0 ]; then
		code=$?
		cleanup
		exit $code
	fi
	if [ "x$pkgfiles" != "x" ]; then
		"echo overriding files in package spec ${SPECFILE}" 
		sed -i -e "s#%files#$pkgfiles#" $SPECFILE
	fi

	rpm="opt-perl-${rpmname}"
	
	# Build the RPM
	rpmbuild -ba ${WORKDIR}/SPECS/${rpm}.spec
	if [ $? -ne 0 ]; then
		code=$?
		cleanup
		exit $code
	fi

	# Install the just-built module. This is to satisfy dependencies for subsequent
	# builds
	if [ ! -f ${WORKDIR}/Makefile ]; then 
		find ${WORKDIR}/RPMS -type f -name "${rpm}-*" -exec yum -y install {} \; -print
	else
		pushd ${WORKDIR}
		make createlocalrepo
		yum -c yum.conf -y install ${rpm}
		popd
	fi
done < $1
cleanup
