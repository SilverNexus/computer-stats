#!/usr/bin/env perl

#    computer_stats.pl - usage aggregation tool for the computer. Best used as a cron job.
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

use strict;
use Getopt::Long;

my $filename = "usage_log.csv";
# Reference to a scalar.
my @disk_path_list;

# Use Getopt to clean up argument parsing
GetOptions("output-file|o=s" => \$filename,
	   "disk-paths|d=s" => \@disk_path_list);

# Get the memory and swap information
my $res = `egrep "Mem|Cache|Swap|Buffer" /proc/meminfo` or die("Could not access memory information.");
# Get the workload information
my $uptime = `uptime` or die("Could not access workload information.");

# Get the time, too
my $time = `date` or die("Could not access time.");
chomp($time);
# And get a list of users
my $userlist = `users` or die("Could not retrieve user list.");
chomp($userlist);

# Get the specified disks' usage
my $disk = `df @disk_path_list` or die("Could not check disk usage.");
my @lines = split("\n", $disk);
# The first line is just titles -- skip it
shift(@lines);

# Split the memory results by line
# We use multiple lines of this, so we do this after the other commands to allow reuse of variables.
my @memlines = split("\n", $res);

#Declare the variables to store the memory information
my $total, my $free, my $swap, my $swfree, my $cache, my $buffers, my $up,
my $load1, my $load5, my$load15, my $numusers, my @disksize, my @diskfree,
my @diskused, my @diskmount, my @diskpct;

#Split out the memory and swap information
for(@memlines){
    if (/^MemTotal:\s*(\d+)/s){
        $total = $1;
    }
    elsif (/^MemFree:\s*(\d+)/s){
        $free = $1;
    }
    elsif (/^SwapTotal:\s*(\d+)/s){
        $swap = $1;
    }
    elsif (/^SwapFree:\s*(\d+)/s){
        $swfree = $1;
    }
    elsif (/^Cached:\s*(\d+)/s){
        $cache = $1;
    }
    elsif (/^Buffers:\s*(\d+)/s){
        $buffers = $1;
    }
}

# Split out the uptime information.
# For the uptime, it needs to handle multiple days of uptime, as well as under an hour.
if ($uptime =~ /\s*\d{2}:\d{2}:\d{2}\s+up\s+((\d+ days?,\s+)?((\d+:\d{2})|(\d+ min))),\s+(\d+) users?,\s+load average:\s+(\d+\.\d{2}),\s+(\d+\.\d{2}),\s+(\d+\.\d{2})/s){
    $up = $1;
    $numusers = $6;
    $load1 = $7;
    $load5 = $8;
    $load15 = $9;
    # Convert the comma from more than one day of uptime to avoid conflicts with the line delimiter.
    $up =~ s/\,/\;/g;
}

# Split out disk information
for (@lines){
    # TODO: Come up with a better way to handle the multiple disks -- current way is ugly.
    if (/^((\/\w+)+)\s*(\d+[GMKT]?)\s*(\d+[GMKT]?)\s*(\d+[GMKT]?)\s*(\d+\%)\s*(\/(\w+\/?)*)/s){
	push(@diskmount, $7);
	push(@disksize, $3);
	push(@diskused, $4);
	push(@diskfree, $5);
	push(@diskpct, $6);
    }
}

# See if the file exists. If not, initialize the new log file with header information
initialize() unless (-e $filename);

# open the output file and append to it.
open(LOG, ">> $filename") or die("Failed to open $filename");
# Separate multiple disks by semicolon for better parsing.
$" = ";";
say LOG "$time, $up, $total, $free, $cache, $buffers, $swap, $swfree, @diskmount, @disksize, @diskused, @diskfree, @diskpct, $load1, $load5, $load15, $numusers, $userlist";
close(LOG);

sub initialize{
    open(LOGINIT, "> $filename") or die("Failed to initialize $filename");
    say LOGINIT "Time, Uptime, RAM Total (KiB), RAM Free (KiB), Cache (KiB), Buffers (KiB), Swap Total (KiB), Swap Free (KiB), Disk Mount Point, Disk Size (KiB), Disk Used (KiB), Disk Available (KiB), Disk Used (%), CPU Load (1 min), CPU Load (5 min), CPU Load (15 min), # Users, Users";
    close(LOGINIT);
}
