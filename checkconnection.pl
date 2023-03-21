#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(sleep);
use POSIX qw(strftime);
use Term::ANSIColor;
use Socket;

my $logfile = "internetcheck.log";
my ($url, $run_duration, $background);

print "Enter a URL or IP address: ";
chomp($url = <STDIN>);

print "Enter duration to run the script (in minutes, 0 for until stopped): ";
chomp($run_duration = <STDIN>);

print "Run in background? (y/n): ";
chomp($background = <STDIN>);

if ($background =~ /y/i) {
    my $pid = fork();
    die "Cannot fork: $!" unless defined($pid);

    if ($pid) {
        print "Script is running in the background with process ID $pid\n";
        exit;
    }
}

my $start_time = time;
my $end_time = ($run_duration == 0) ? undef : $start_time + $run_duration * 60;

while (!defined($end_time) || time <= $end_time) {
    my $timestamp = strftime "%Y-%m-%d %H:%M:%S", localtime;
    my $ping_result = system("ping -c 1 $url >/dev/null 2>&1");

    open(my $fh, '>>', $logfile) or die "Could not open file '$logfile' $!";
    if ($ping_result == 0) {
        my $ip_address = $url;
        $ip_address = inet_ntoa(inet_aton($url)) if ($url !~ /^\d+\.\d+\.\d+\.\d+$/);

        print $fh "$timestamp - Connectivity check OK: $url ($ip_address)\n";
        print color('green');
        print "[$timestamp] Connectivity check OK: $url ($ip_address)\n";
        print color('reset');

    } else {
        print $fh "$timestamp - WARNING: No Connectivity\n";
        print color('red');
        print "[$timestamp] WARNING: No Connectivity\n";
        print color('reset');
    }
    print $fh "\n";
    close $fh;

    sleep(100);
}
