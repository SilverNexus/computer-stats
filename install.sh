#!/bin/sh

# install.sh -- Install script for computer-stats
#    Copyright (C) 2016  SilverNexus
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

if [ $USER != "root" ];
then
    echo "You need to run this script as root to install."
    exit 1
fi

line="*/10 * * * * root perl /etc/cron.d/computer-stats.pl $*"

cp computer-stats.pl /etc/cron.d/

# Make sure we dont already have a line in the crontab. If we do, remove it.
res=`grep -e "computer-stats.pl" /etc/crontab`

if [ "$res" != "" ];
then
    # Replace that line in crontab with a new one.
    # Writing directly to crontab creates an empty file, so we make a new file,
    # then turn around and copy it back to crontab
    sed "/computer-stats.pl/ c $line" /etc/crontab > /etc/crontab_new
    mv /etc/crontab_new /etc/crontab
    touch /etc/crontab
else
    # Just append it to the crontab
    echo "$line" >> /etc/crontab
fi
