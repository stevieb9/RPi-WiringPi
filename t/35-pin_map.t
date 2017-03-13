use strict;
use warnings;

use RPi::WiringPi;
use RPi::WiringPi::Constant qw(:all);
use Test::More;

my $mod = 'RPi::WiringPi';

if (! $ENV{PI_BOARD}){
    warn "\n*** PI_BOARD is not set! ***\n";
    $ENV{NO_BOARD} = 1;
    plan skip_all => "not on a pi board\n";
}

{
    my $pi = RPi::WiringPi->new(setup => 'none');

    is $pi->pin_scheme, -1, "pin_scheme() returns NULL if not set";
    is $pi->pin_scheme('BCM'), 'BCM', "pin_scheme() returns BCM if setup() is sys";
    is $pi->pin_scheme('GPIO'), 'GPIO', "pin_scheme() returns GPIO if setup() is gpio";
    is $pi->pin_scheme('PHYS_GPIO'), 'PHYS_GPIO', "pin_scheme() returns BCM if setup() is phys";
    is (
        $pi->pin_scheme('WPI'),
        'WPI', 
        "pin_scheme() returns 'wiringPi' if setup() is wiringPi"
    );
}

SKIP: {
    my $pi = RPi::WiringPi->new;
    warn "t/35 gpio_map() test needs investigating...\n";
    skip "FIXME: dont' know why this test fails", 1;
    my $map = $pi->gpio_map('BCM');
    print "$map->{40}\n";
}

done_testing();
