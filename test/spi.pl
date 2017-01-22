use warnings;
use strict;
use feature 'say';

use RPi::WiringPi;

my $pi = RPi::WiringPi->new;

my $spi = $pi->spi(0);

my $buf = [0x01, 0x02];
my $len = scalar @$buf;

my $ok = $spi->rw($buf, $len);

say $ok;
