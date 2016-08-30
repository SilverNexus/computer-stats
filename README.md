computer-stats - a computer metric aggregation script

## Usage

computer-stats.pl [-o output-file] [-d disk mount]

Note: The -d flag can be used any number of times to specify additional directories.
	It should also be noted that the measurement takes place for the mount point
	of the disk used at the directory specified.
Example: A single disk, single partition install will have all -d paths give disk
	stats for /.
	Other configurations will use the partition mount point for the
	specified directory.

## Requirements

1. Perl 5.14 or newer.
2. A Unix-like system. Possibly specifically Linux, but more testing is needed to verify.

## Installation

**Linux**

Run install.sh, providing any arguments for the cron job to the script.
install.sh will need superuser privileges to operate correctly.

Example: `sudo install.sh -o /var/log/output.csv -d /home -d /` will make the logfile be written
at `/var/log/output.csv` and the program will check the disk space of the partitions at `/home` and `/`.

**Windows**

There is no Windows-compatible version for this script at this time.

**Mac OS X**

Memory information fails due to a lack of /proc/meminfo. Not compatible without modification.

**BSD**

Try Linux instructions above. Not tested whether this will work or not.

## Build Status

[![tv-image][]][tv-site]

[tv-image]: https://travis-ci.org/SilverNexus/computer-stats.svg?branch=master
[tv-site]: https://travis-ci.org/SilverNexus/computer-stats/branches

## License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
