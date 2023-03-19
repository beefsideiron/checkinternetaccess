#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(sleep);
use POSIX qw(strftime);

my $logfile = "internetcheck.log";
my $host = "www.dr.dk";

while (1) {
    my $timestamp = strftime "%Y-%m-%d %H:%M:%S", localtime;
    my $ping_result = system("ping -c 1 $host >/dev/null 2>&1");

    open(my $fh, '>>', $logfile) or die "Could not open file '$logfile' $!";
    if ($ping_result == 0) {
        print $fh "$timestamp - Connectivity OK\n";
        my $traceroute_output = `traceroute $host`;
        print $fh $traceroute_output;
    } else {
        print $fh "$timestamp - WARNING: No Connectivity\n";
    }
    print $fh "\n";
    close $fh;

    sleep(300);
}

