#!/bin/bash

# $Id: bootstrap.sh,v 1.1 2011/06/16 18:00:27 anoop Exp $

# @Copyright@
# @Copyright@

# $Log: bootstrap.sh,v $
# Revision 1.1  2011/06/16 18:00:27  anoop
# Start of a perl roll
#

. $ROCKSROOT/src/roll/etc/bootstrap-functions.sh

compile perl
install opt-perl

compile cpan
install rocks-cpan

(cd src/cpan-support && gmake bootstrap)
