PKGROOT		= /opt/perl
NAME    	= opt-perl
ARCHIVE_NAME	= perl
VERSION 	= 5.26.0
PERLVERSION	= 5.014002
RELEASE 	= 1
EXTUTILS_MM	= ExtUtils-MakeMaker
EXTUTILS_MM_VERSION = 6.62
TARBALL_POSTFIX	= tar.gz
RPM.EXTRAS	= AutoReq: no\nProvides: opt-perl = $(VERSION)\nProvides: perl(:MODULE_COMPAT_$(VERSION))
RPM.FILES	= $(PKGROOT)
