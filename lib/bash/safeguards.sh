# This program is copyright 2011 Percona Inc.
# Feedback and improvements are welcome.
#
# THIS PROGRAM IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
# MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, version 2; OR the Perl Artistic License.  On UNIX and similar
# systems, you can issue `man perlgpl' or `man perlartistic' to read these
# licenses.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA.
# ###########################################################################
# safeguards package
# ###########################################################################

# Package: safeguards
# safeguards is a collection of function to help avoid blowing things up.

set -u

disk_space() {
   local filesystem=${1:-"$PWD"}
   # Filesystem    512-blocks       Used  Available  Capacity  Mounted on
   # /dev/disk0s2   236306352  190223184   45571168       81%  /
   df -m -P $filesystem
}

check_disk_space() {
   local file=$1
   local mb=${2:-"0"}
   local pct=${3:-"0"}

   local avail=$(cat $file | awk '/^\//{print $4}');
   local full=$(cat $file  | awk '/^\//{print $5}' | sed -e 's/%//g');
   if [ "${avail}" -le "$mb" -o "$full" -le "$pct" ]; then
      echo "Not enough free space (${full}% full, ${avail}MB free)"
      echo "Wanted less than ${pct}% full and more than ${mb}MB"
      return 1
   fi
   return 0
}


# ###########################################################################
# End safeguards package
# ###########################################################################
