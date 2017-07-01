use strict;
use warnings;

use Data::Dumper;
use RPi::WiringPi;
use Test::More;

my $mod = 'RPi::WiringPi';

if (! $ENV{PI_BOARD}){
    warn "\n*** PI_BOARD is not set! ***\n";
    $ENV{NO_BOARD} = 1;
    plan skip_all => "not on a pi board\n";
}

my $pi = $mod->new(fatal_exit => 0);

{# register, unregister

    my $pin26 = $pi->pin(26);
    my $pin12 = $pi->pin(12);
    my $pin18 = $pi->pin(18);

    my %pin_map = (
        26 => $pin26,
        12 => $pin12,
        18 => $pin18,
    );


    my $pins = $pi->registered_pins;
    is ((split /,/, $pins), 3, "proper num of pins registered");

    for (keys %pin_map){
        is $pin_map{$_}->num, $_, "\$pin$_ has proper num()";
    }
}

$pi->cleanup;

is $pi->registered_pins, undef, "after cleanup, all pins unregistered";

done_testing();
