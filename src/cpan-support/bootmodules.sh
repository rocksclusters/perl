#!/bin/sh
while read mod
do
	echo $mod | grep -q '^#'
	if [ $? -eq 0 ]; then
		echo $mod
		continue
	fi
	modperl=$(echo $mod | awk '{print $1}')
	# Check of name has a - as the first letter, if so, don't run tests
	echo $modperl | grep -q '^-'
	if [ $? -eq 0 ]; then
		runtests="-n"
		modperl=$(echo $modperl | sed 's/-//')
	else
		runtests=""
	fi


	rpmalt=$(echo $mod | awk '{print $2}')
	if [ "$rpmalt" == "" ]; then
		rpmname=$(echo $modperl | sed 's/::/-/g')
	else
		rpmname=$rpmalt
	fi
	echo $modperl $rpmname $runtests
	/usr/bin/yes | /opt/perl/bin/cpantorpm  $runtests --rem-require "perl(LWP::MediaTypes)" --add-require "opt-perl" --install-base /opt/perl --prefix opt-perl- --packager Rocks --spec-only $modperl
	if [ $? -ne 0 ]; then
		exit $?
	fi
	(cd /tmp/rpm/SOURCES; /opt/perl/bin/cpan -g $modperl)
	/bin/sed -i -e "s#^%setup -T -D#%setup #" -e 's#perl/lib/perl5#perl/lib#g' /tmp/rpm/SPECS/opt-perl-${rpmname}.spec
	rpm="opt-perl-${rpmname}-*"
	rpmbuild -ba /tmp/rpm/SPECS/opt-perl-${rpmname}.spec
	find /tmp/rpm/RPMS -type f -name $rpm -exec yum -y install {} \; -print
	
done < $1
