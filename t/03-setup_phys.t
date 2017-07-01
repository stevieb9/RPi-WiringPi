use strict;
use warnings;

use RPi::WiringPi;
use RPi::WiringPi::Constant qw(:all);
use Test::More;

if (! $ENV{PI_BOARD}){
    warn "\n*** PI_BOARD is not set! ***\n";
    $ENV{NO_BOARD} = 1;
    plan skip_all => "not on a pi board\n";
}

{
    my $pi = RPi::WiringPi->new(setup => 'phys');
    is $pi->pin_scheme, 3, "setup is setup_phys(), pinmap is PHYS";
    $pi->cleanup;
}

done_testing();
