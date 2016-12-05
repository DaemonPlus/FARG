#!/bin/sh

# FARG - Removes unseeable and ghost alpha from PNG images.
# Copyright 2016 Daemon Lee Schmidt

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Flags
GHOSTBUST=1
RMUNSEEABLEALPHA=1

checkAlpha () {
  test $(identify -format %A "$1") == True
}

if checkAlpha "$1"; then
  mean=$(convert "$1" -verbose info: | grep -m1 -A3 Alpha: | sed -e :a -e '$q;N;1,$D;ba' | sed -r 's/.*\(|\)//g')
  min=$(convert "$1" -verbose info: | grep -m1 -A1 Alpha: | sed -e :a -e '$q;N;1,$D;ba' | sed -e 's/([^()]*)//g;s/[^0-9]*//g')

  if ((`bc <<< "$mean==1 && $min==255"`)); then
    echo "ghost alpha bro - $1 - $mean - $min"
    if [[ GHOSTBUST ]]; then
      mogrify -alpha off "$1"
    fi

  elif ((`bc <<< "$mean>0.999500 || $min>=254"`)); then
    echo "flatten - $1 - $mean - $min"
    if [[ RMUNSEEABLEALPHA ]]; then
      mogrify -flatten -alpha off "$1"
    fi

  else
    echo "transparent - $1 - $mean - $min"
  fi
fi
