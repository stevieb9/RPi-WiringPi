#!/usr/bin/env perl

use warnings;
use strict;

use RPi::WiringPi;

my $pi = RPi::WiringPi->new(label => 'serial_arduino_display');
my $dev = '/dev/ttyS0';
my $baud = 9600;

my $s = $pi->serial($dev, $baud);

use constant {
    BIT_BSMT        => 0,
    BIT_BSMT_DOOR   => 1,
    BIT_MAIN        => 2,
    BIT_ALARM           => 3,
};



while (1){
    my $cpu = int $pi->cpu_percent;
    my $mem = int $pi->mem_percent;
    my $tmp = int $pi->core_temp('f');
    my $test_num = int test_num();

    if (! defined $test_num || $test_num == -1){
        $test_num = 0; 
    }

    my $sec_byte = sec_byte();
    $s->putc(chr $sec_byte);

    $s->putc(chr $cpu);
    $s->putc(chr $mem);
    $s->putc(chr $tmp);

    my $msb = int($test_num >> 8);
    my $lsb = int($test_num & 0xFF);

    # print "cpu: $cpu, mem: $mem, temp: $tmp, msb: $msb, lsb: $lsb, num: $num test_num: $test_num\n";

    $s->putc(chr $msb);
    $s->putc(chr $lsb);

    print "cpu: $cpu, mem: $mem, tmp: $tmp, msb: $msb, lsb: $lsb, sec: $sec_byte\n";

    sleep 1;
}

sub test_num {

    $pi->meta_lock;
    my $meta = $pi->meta_fetch;
    my $test_num = $meta->{testing}{test_num};
    $pi->meta_unlock;

    if (defined $test_num && $test_num > 0){
        return $test_num;
    }
    else {
        return -1;
    }
}
