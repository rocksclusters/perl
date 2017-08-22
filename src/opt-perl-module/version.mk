# Get the PERL version from it's version.mk file. 
PERLVERSION = $(shell awk '/^VERSION/{printf("%s",$$NF)}' $(CURDIR)/../perl/version.mk)

PKGROOT		= /usr/share/Modules/modulefiles
NAME		= opt-perl-module
RELEASE		= 0
RPM.REQUIRES	= environment-modules
RPM.FILES	= $(PKGROOT)/*
VERSION		= $(PERLVERSION)
