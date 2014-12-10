use strict;
use warnings;
use Socket qw(inet_ntoa inet_aton);

my @masks = map { pack("B*", substr("1" x $_ . "0" x 32, 0, 32))
                } 0..32;

my @bits2rng = map { 2**(32 - $_) } 0..32;
my %rng2bits = map { $bits2rng[$_] => $_ } 0..32;

my %ips;
while (<>) {
    my ($ip, $mask) = split "/";
    my $start = inet_aton($ip) & $masks[$mask];
    my $end = pack("N", unpack("N", $start) + $bits2rng[$mask]);
    $ips{$start}++;
    $ips{$end}--;
}

my ($start, $total);
for my $ip (sort keys %ips) {
    $start = $ip unless $total;
    unless ($total+=$ips{$ip}) {
        my $diff = unpack("N", $ip) - unpack("N", $start);
        while ($diff) {
            (my $zeros = unpack("B*", $start)) =~ s/^.*1//;
            my $range;
            for my $i (32-length($zeros)..32) {
                $range=$bits2rng[$i], last if $bits2rng[$i]<=$diff;
            }
            print inet_ntoa($start), "/", $rng2bits{$range}, "\n";
            $start = pack("N", unpack("N", $start)+$range);
            $diff -= $range;
        }
    }
}

