#!/usr/bin/perl
# attackers 2, with ipv6 support.
# output connection information from netstat
#

use strict;

sub run {
        my @netstat = `netstat -pant`;

        my $portcheck = $ARGV[0];
        if ( $portcheck =~ /^[0-9]+$/ ) {
                my %ports;
                my %ips;
                foreach (@netstat) {
                        my ($port, $ip);
                        if ( /^tcp\s+\d\s+\d\s+[0-9\.|0-9A-Za-z\.:]+:${portcheck}\s+([0-9\.|0-9A-Za-z\.:]+):/ ) {
                                chomp;
                                $ip = $1;
                                if ( $ip !~ /^::$/ ) {
                                        $ips{$ip}++;
                                }
                        }
                }
                my $count;
                print "[+] Highest connections on port $portcheck\n";
                foreach my $number ( sort {$ips{$b} <=> $ips{$a}} keys %ips ) {
                        if ( $count <= 10 ) {
                                if ($number) {
                                        print "\t$ips{$number} $number\n";
                                        $count++;
                                }
                        }
                }
                my $total;
                foreach my $key ( keys %ips ) {
                        if ($key) {
                                $total += $ips{$key};
                        }
                }
                print "\n[+] TOTAL: $total\n";
        } else {
                my %ports;
                my %ips;
                foreach (@netstat) {
                        my ($port, $ip);
                        if ( /^tcp\s+\d\s+\d\s+[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:([0-9]+)\s+([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}):[0-9]+\s+/ ) {
                                chomp;
                                $port = $1;
                                $ip = $2;
                        } elsif ( /^tcp\s+\d\s+\d\s+[0-9\.|0-9A-Za-z\.:]+:([0-9]+)\s+([0-9\.|0-9A-Za-z\.:]+):[0-9]+\s+/ ) {
                                chomp;
                                $port = $1;
                                $ip = $2;
                        }
                        $ports{$port}++;
 $ips{$ip}++;
                }

                my $count;
                print "[+] Número de Conexões por IP:\n";
                foreach my $number ( sort {$ips{$b} <=> $ips{$a}} keys %ips ) {
                        if ( $count <= 10 ) {
                                if ($number) {
                                        print "\t$ips{$number} $number\n";
                                        $count++;
                                }
                        }
                }

                $count = 0;
                print "\n[+] Número de Conexões por porta:\n";
                foreach my $number ( sort {$ports{$b} <=> $ports{$a}} keys %ports ) {
                        if ( $count <= 10 ) {
                                if ($number) {
                                        print "\t$ports{$number} $number\n";
                                        $count++;
                                }
                        }
                }

                my $total;
                foreach my $key ( keys %ports ) {
                        if ($key) {
                                $total += $ports{$key};
                        }
                }

                print "\n[+] TOTAL: $total\n";
        }
}

run();

