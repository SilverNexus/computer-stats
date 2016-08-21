computer-stats - a computer metric aggregation script

## Usage

As of this time, the script takes no arguments. Just run it and it should work.

## Installation

**Linux**

1. Copy computer-stats.pl to /etc/cron.d/
2. run `crontab -e`
3. Add the following line to the crontab:
*/10 * * * * perl /etc/cron.d/computer-stats.pl
This will make the script run every ten minutes.
4. Exit the text editor that crontab -e opened and save your changes if not done already.
This automatically updates cron to read the new crontab, so no further action is required.

This will result in the generated csv being written to your home folder. It should be called usage_log.csv.

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
