use strict;
use warnings;

use lib 't/';

use RPiTest qw(check_pin_status);
use RPi::WiringPi;
use Test::More;

my $mod = 'RPi::WiringPi';

if ($> == 0){
    $ENV{PI_BOARD} = 1;
}

if (! $ENV{PI_BOARD}){
    warn "\n*** PI_BOARD is not set! ***\n";
    $ENV{NO_BOARD} = 1;
    plan skip_all => "not on a pi board\n";
    exit;
}

if ($> != 0){
    print "enforcing sudo for PWM tests...\n";
    system('sudo', 'perl', $0);
    exit;
}

my $pi = $mod->new;

my $adc_in = 7;

if (! $ENV{NO_BOARD}) {
    my $pin = $pi->pin(18);
    $pin->mode(2);
    is $pin->mode, 2, "pin mode set to PWM ok, and we can read it";
    $pi->cleanup;

    check_pin_status();
}

$pi->cleanup;

done_testing();
