#!/bin/sh
#
# hostname.sh	Set hostname.
#
# Version:	@(#)hostname.sh  1.10  26-Feb-2001  miquels@cistron.nl
#

#echo "We are: $0 : $1"

if test -f /etc/hostname
then
	hostname -F /etc/hostname
fi

