use strict;
use warnings;

use lib 't/';

use RPiTest;
use Test::More;
use RPi::Const;
use RPi::WiringPi;

if (! $ENV{RPI_OLED}){
    plan skip_all => "RPI_OLED environment variable not set\n";
}

if (! $ENV{PI_BOARD}){
    $ENV{NO_BOARD} = 1;
    plan skip_all => "Not on a Pi board\n";
}

rpi_running_test(__FILE__);

rpi_oled_unavailable();
is rpi_oled_available(), 0, "oled unavailable for use ok";

my $s = RPi::WiringPi->oled('128x64', 0x3C, 0);

is ref $s, 'RPi::OLED::SSD1306::128_64', "oled() returns an object of proper class";

done_testing();

