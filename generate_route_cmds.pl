#!/usr/bin/perl
use strict;
use warnings;
use Net::Netmask;
 
sub _calc_netmask {
    my($subnet) = @_;
 
    # e.g.: 10.0.0.0/24 192.168.1.0/16
    my $block = Net::Netmask->new($subnet);
 
    
    return($block->base(), $block->mask());
}
 
while(<>){
    chomp;
    my $line=$_;
    my ($ip,$mask)= _calc_netmask($line);
    printf("route add $ip mask $mask %%1 \n");
}
