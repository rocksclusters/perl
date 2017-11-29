# $Id: Makefile,v 1.5 2013/01/22 22:13:58 clem Exp $

# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 6.2 (SideWindwer)
# 		         version 7.0 (Manzanita)
# 
# Copyright (c) 2000 - 2017 The Regents of the University of California.
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
# Revision 1.5  2013/01/22 22:13:58  clem
# With this last fix the yum check repo should now be clean!!
#
# there was a missing dependency in opt-cpan which was wrong. I disabled it.
#
# Revision 1.4  2012/11/27 00:49:11  phil
# Copyright Storm for Emerald Boa
#
# Revision 1.3  2012/05/06 05:49:18  phil
# Copyright Storm for Mamba
#
# Revision 1.2  2011/07/23 02:31:15  phil
# Viper Copyright
#
# Revision 1.1  2011/06/16 18:00:28  anoop
# Start of a perl roll
#
# Revision 1.4  2010/09/07 23:53:04  bruno
# star power for gb
#
# Revision 1.3  2010/06/22 21:26:22  mjk
# Build env is now from src/devel package, nothing outside of base roll.
#
# Revision 1.2  2009/11/18 22:16:56  anoop
# - Big changes to rocks-cpan. Now more accurate.
# - CPAN Support introduced. Builds and installs the
#   necessary infrastucture to get CPANPLUS::Dist::Rocks
#   to function correctly
# - Changes to xml files to include CPAN packages and support
#   infrastructure
#
# Revision 1.1  2009/11/10 21:32:28  anoop
# Install CPAN config files to help create RPM files from CPAN directly
# Make sure to build and install rocks-cpan during bootstrap of the base roll
# Include CPAN support on solaris as well. All CPAN files are only for
# foundation-perl
#

REDHAT.ROOT     = $(CURDIR)/../../
-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(REDHAT.ROOT)/Rules-perl.mk

RPM.EXTRAS += "AutoReqProv: no"


build:

install::
PKGROOT = `eval "\`$(PERL) -V:privlibexp\`" ; echo $$privlibexp`
SITEROOT = `eval "\`$(PERL) -V:installsitelib\`" ; echo $$installsitelib`
install::
	# Create all the necessary directories
	mkdir -p $(ROOT)/$(PKGROOT)
	mkdir -p $(ROOT)/$(PKGROOT)/CPAN
	mkdir -p $(ROOT)/$(PKGROOT)/CPANPLUS/Config
	mkdir -p $(ROOT)/$(SITEROOT)/CPANPLUS/Dist
	mkdir -p $(ROOT)/$(SITEROOT)/CPANPLUS/Module
	# Install relevant files
	$(INSTALL) -m0544 Config.pm $(ROOT)/$(PKGROOT)/CPAN
	$(INSTALL) -m0544 System.pm $(ROOT)/$(PKGROOT)/CPANPLUS/Config/
	$(INSTALL) -m0544 Rocks.pm $(ROOT)/$(SITEROOT)/CPANPLUS/Dist/
	$(INSTALL) -m0544 Signature.pm $(ROOT)/$(SITEROOT)/CPANPLUS/Module/
