use strict;
use warnings;

use lib 't/';

use RPiTest;
use Test::More;
use RPi::WiringPi;

if (! $ENV{RPI_OLED}){
    plan skip_all => "RPI_OLED environment variable not set\n";
}

if (! $ENV{PI_BOARD}){
    $ENV{NO_BOARD} = 1;
    plan skip_all => "Not on a Pi board\n";
}

rpi_running_test(__FILE__);

my $pi = RPi::WiringPi->new;
my $s = $pi->oled('128x64', 0x3C, 1);

$s->display;

ok 1;

$pi->cleanup;

rpi_check_pin_status();
rpi_metadata_clean();

done_testing();

