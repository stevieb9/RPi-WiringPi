use strict;
use warnings;

use lib 't/';

use RPiTest;
use RPi::WiringPi;
use RPi::Const qw(:all);
use Test::More;

my $mod = 'RPi::WiringPi';

plan skip_all => "SERIAL TESTS CURRENTLY DISABLED";

if (! $ENV{RPI_SERIAL}){
    plan skip_all => "RPI_SERIAL environment variable not set\n";
}

if (! $ENV{PI_BOARD}){
    $ENV{NO_BOARD} = 1;
    plan skip_all => "Not on a Pi board\n";
}

rpi_running_test(__FILE__);

my $pi = $mod->new;

my $s = $pi->serial("/dev/ttyS0", 115200);

isa_ok $s, 'RPi::Serial';

for (0..255) {
    $s->putc($_);
    is $s->getc, $_, "putc() and getc() $_ ok";
}

$s->puts("hello, world!");

# for troubleshooting extra char in string

#my $res = $s->gets(13);
#if( !is $res, "hello, world!", "puts() and gets() ok") {
#    (my $s = $res) =~ s!([^\w])!sprintf '\\x%02x', ord($1)!ge;
#    diag $s;
#    ($s = "hello, world!") =~ s!([^\w])!sprintf '\\x%02x', ord($1)!ge;
#    diag $s;
#};

like $s->gets(13), qr/^hello, world!/, "puts() and gets() ok";

$pi->cleanup;

rpi_check_pin_status();
rpi_metadata_clean();

done_testing();
