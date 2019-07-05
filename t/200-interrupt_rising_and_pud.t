use strict;
use warnings;

use lib 't/';

use RPiTest;
use RPi::WiringPi;
use RPi::Const qw(:all);
use Test::More;

rpi_running_test(__FILE__);

my $mod = 'RPi::WiringPi';

if (! $ENV{PI_BOARD}){
    $ENV{NO_BOARD} = 1;
    plan skip_all => "Not on a Pi board\n";
}

BEGIN {
    my $c;

    sub handler {
        $c++;
        $ENV{PI_INTERRUPT} = $c;
    }
}

my $pi = $mod->new;

# pin specific interrupts

my $pin = $pi->pin(18);

if (! $ENV{NO_BOARD}){

    # EDGE_RISING

    $pin->set_interrupt(EDGE_RISING, 'main::handler');

    $pin->pull(PUD_DOWN);

    # trigger the interrupt

    $pin->pull(PUD_UP);
    $pin->pull(PUD_DOWN);

    is $ENV{PI_INTERRUPT}, 1, "1st interrupt ok";

    # trigger the interrupt

    $pin->pull(PUD_UP);
    $pin->pull(PUD_DOWN);
    
    is $ENV{PI_INTERRUPT}, 2, "2nd interrupt ok";

    # trigger the interrupt

    $pin->pull(PUD_UP);
    $pin->pull(PUD_DOWN);
    
    is $ENV{PI_INTERRUPT}, 3, "3rd interrupt ok";
    
}

$pi->cleanup;

rpi_check_pin_status();
rpi_metadata_clean();

done_testing();
