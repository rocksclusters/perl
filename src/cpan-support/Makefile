# $Id: Makefile,v 1.10 2013/02/05 18:29:56 clem Exp $

# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 6.2 (SideWinder)
# 
# Copyright (c) 2000 - 2014 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@

# $Log: Makefile,v $
# Revision 1.10  2013/02/05 18:29:56  clem
# last fix to properly set the release number
#
# in makefile you need to expicitly export a variable to make it visible to the
# subshells
#
# Revision 1.9  2013/02/05 01:17:12  clem
# fix make clean so it doesnt wipe version.mk
#
# Revision 1.8  2012/11/27 00:49:11  phil
# Copyright Storm for Emerald Boa
#
# Revision 1.7  2012/05/06 05:49:19  phil
# Copyright Storm for Mamba
#
# Revision 1.6  2012/04/25 02:05:01  phil
# Perl sucks and here's why. The latest version of perl supplies MakeMaker
# version 6.57, but some of the support packages require version 6.62.
#
# So we have to build newer version of MakeMaker. But MakeMaker is required to
# build perl in the first place. Can you drop in the 6.62 tree into the
# perl tree and update the source? Of course not.
#
# Instead, you have create an alternate package. But now the perl and makeMaker rpms collide.  basically, no win.  Having software rely on versions beyond the latest release is brain dead. Welcome to bio and perl code.
#
# Revision 1.5  2011/07/23 02:31:15  phil
# Viper Copyright
#
# Revision 1.4  2011/07/20 20:17:13  anoop
# Separate bootstrap and build lists.
# This way bootstrap takes less time than build
#
# Revision 1.3  2011/07/20 06:34:18  anoop
# Bug fixes to Makefile. Make sed parsing a bit more accurate
#
# Revision 1.2  2011/07/20 03:04:45  anoop
# Update ignorelists dynamically
# Make the sed parsing a bit more accurate
#
# Revision 1.1  2011/06/16 18:00:28  anoop
# Start of a perl roll
#
# Revision 1.5  2010/09/07 23:53:04  bruno
# star power for gb
#
# Revision 1.4  2010/06/22 21:26:22  mjk
# Build env is now from src/devel package, nothing outside of base roll.
#
# Revision 1.3  2009/11/20 23:38:38  bruno
# from anoop:
# 	Disable building and installation of rocks-cpan and cpan-support on
# 	Solaris. Will re-enable for next release after testing.
#
# Revision 1.2  2009/11/19 21:10:34  bruno
# patch from anoop
#
# Revision 1.1  2009/11/18 22:16:56  anoop
# - Big changes to rocks-cpan. Now more accurate.
# - CPAN Support introduced. Builds and installs the
#   necessary infrastucture to get CPANPLUS::Dist::Rocks
#   to function correctly
# - Changes to xml files to include CPAN packages and support
#   infrastructure
#

REDHAT.ROOT = $(CURDIR)/../..
MAKE.iscontrib = 1
-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(REDHAT.ROOT)/Rules-perl.mk




# 
# You can use now RocksReleaseVersion to set the release version of the RPMs
# builded by cpan see below..
#
ifdef RELEASE
export RocksReleaseVersion = $(RELEASE)
endif

SEPARATOR = -------------------------------------------------------------

# Target to install all the required CPAN modules
# for CPANPLUS::Dist::Rocks to function correctly
# on a vanilla system
bootstrap:
	cat modules.bootstrap | while read line; do \
		/opt/perl/bin/cpan $$line < /dev/null; \
		done

# Make sure we don't build the CPAN modules which are already
# a part of opt-perl. This is done by creating modules.ignore 
build:
	rpm -q --provides opt-perl | \
		 grep -E "^perl\(" | \
		sed -r -e \
		's/^perl\(/^/' -e 's/\)[ \t]*(=[ \t]*[.0-9]+)*$$/$$/' | \
		sort | grep -v ExtUtils::MakeMaker > modules.ignore;

# Use modules.build and modules.ignore to convert from CPAN to Rocks RPM
install::
	cp modules.ignore modules.ignore.tmp
	cat modules.build | while read line; do \
		echo $(SEPARATOR) building $$line $(SEPARATOR);\
		/opt/perl/bin/cpan2dist --format CPANPLUS::Dist::Rocks	\
		--ignorelist modules.ignore.tmp --buildprereq --force	\
		--install --verbose $$line < /dev/null;			\
		( find . -type f -name \*.rpm	\
		-exec rpm -qlp {} \;	\
		|/usr/lib/rpm/find-provides \
		| grep -E "^perl\(" | sed -r -e \
		's/^perl\(/^/' -e 's/\)[ \t]*(=[ \t]*[.0-9]+)*$$/$$/' \
		&& cat modules.ignore )| sort |	\
		uniq > modules.ignore.tmp;	\
	done
#	/opt/perl/bin/cpan2dist --format CPANPLUS::Dist::Rocks	\
#	--ignorelist modules.ignore --buildprereq --force	\
#	--verbose --install --modulelist modules.build < /dev/null; 

# Transfer all the RPMS to the Roll RPM  repository.
rpm:: build install
	if [ ! -d $(REDHAT.ROOT)/RPMS ]; then mkdir -p $(REDHAT.ROOT)/RPMS; fi
	for i in `find . -type f -name \*.rpm ! -name \*.src.rpm`; do \
		rpmname=`basename $$i`; \
		arch=`echo $$rpmname | awk -F. '{print $$(NF-1);}'`; \
		echo $$arch; \
		if [ ! -d $(REDHAT.ROOT)/RPMS/$$arch ]; then \
			mkdir -p $(REDHAT.ROOT)/RPMS/$$arch; fi; \
		cp -rvf $$i $(REDHAT.ROOT)/RPMS/$$arch; \
	done

# Clean out everything that's not Makefile or modules.build or CVS
clean::
	find * -prune ! -name CVS \
		! -name Makefile -a 	\
		! -name modules.build -a\
		! -name version.mk -a\
		! -name modules.bootstrap\
		 -exec rm -rf {} \;
	-rm -rf .gnupg
