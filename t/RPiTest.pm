package RPiTest;

use warnings;
use strict;

use Exporter;
our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
    running_test
    check_pin_status 
    oled_available 
    oled_unavailable
);

use Carp qw(croak);
use IPC::Shareable;
use Test::More;
use WiringPi::API qw(:perl);

tie my %shared_pi_info, 'IPC::Shareable', {
    key => 'rpiw',
    create => 0,
};

my $oled_lock = '/tmp/oled_unavailable.rpi-wiringpi';

sub running_test {
    (my $test) = @_;

    if ($test =~ m|t/(\d+)-(.*)\.t|){
        $shared_pi_info{testing}->{test_num} = $1;
        $shared_pi_info{testing}->{test_name} = $2;
        return 0;
    }
    elsif ($test =~ /^-\d+/){
        $shared_pi_info{testing}->{test_num} = -1;
        $shared_pi_info{testing}->{test_name} = '';
        return 0;
    }

    croak
        "running_test() couldn't translate '$test' to a usable shared format\n";
}
sub oled_available {
    my ($available) = @_;

    if ($available) {
        if (-e $oled_lock) {
            unlink $oled_lock or die $!;
        }
    }

    return -e $oled_lock ? 0 : 1;
}
sub oled_unavailable {
    open my $wfh, '>', $oled_lock or die $!;
    close $wfh;

    return -e $oled_lock ? 1 : 0;
}
sub check_pin_status {

    setup_gpio();

    # pins 4, 5, 6, 17, 22, 27 removed because of LCD

    my $oled_locked = -e '/tmp/oled_in_use';

    note "I2C locked due to external OLED software running; skipping pins 2 and 3";

    my @gpio_pins;

    if ($oled_locked) {
        @gpio_pins = qw(
            14 15 18 23 24 10 9 25 11 8 7 0 1 13 19 16 20 21
        );
    }
    else {
        @gpio_pins = qw(
            2 3 14 15 18 23 24 10 9 25 11 8 7 0 1 13 19 16 20 21
        );
    }
    my $config = default_pin_config();

    for (@gpio_pins){
        if ($_ == 14 || $_ == 15){
            # serial pins
            my $alt = get_alt($_);
            ok $alt == $config->{$_}{alt} || $alt == 2, "pin $_ set back to default mode ($alt) ok";
            is read_pin($_), $config->{$_}{state}, "pin $_ set back to default state ($config->{$_}{state}) ok";
            next;
        }
        is get_alt($_), $config->{$_}{alt}, "pin $_ set back to default mode ($config->{$_}{alt}) ok";
        is read_pin($_), $config->{$_}{state}, "pin $_ set back to default state ($config->{$_}{state}) ok";
    }
}
sub default_pin_config {
    # default pin configurations

    my $pin_conf = {
      '3' => {
               'alt' => 4,
               'state' => 1
             },
      '4' => {
               'state' => 1,
               'alt' => 0
             },
      '17' => {
                'state' => 1,
                'alt' => 0
              },
      '15' => {
                # alt 4 (ALT0) when Serial bluetooth disabled
                'state' => 1,
                'alt' => 4
              },
      '23' => {
                'state' => 0,
                'alt' => 0
              },
      '25' => {
                'state' => 0,
                'alt' => 0
              },
      '24' => {
                'alt' => 0,
                'state' => 0
              },
      '13' => {
                'state' => 0, # state: HIGH:   due to the dpot test (t/50)
                'alt' => 0    # mode:  OUTPUT: due to the dpot test (t/50)
              },
      '1' => {
               'state' => 1,
               'alt' => 0
             },
      '27' => {
                # hot due to LCD
                'state' => 1,
                'alt' => 0
              },
      '16' => {
                'state' => 0,
                'alt' => 0
              },
      '18' => {
                'state' => 0,
                'alt' => 0
              },
      '22' => {
                'alt' => 0,
                'state' => 1
              },
#FIXME: removed due to inherent flipping
#      '26' => {
#                #FIXME: don't know why this one goes from
#                # INPUT to ALT0
#                'state' => 0,
#                'alt' => 4
#              },
      '6' => {
               'state' => 1,
               'alt' => 0
             },
      '7' => {
               'alt' => 1,
               'state' => 1
             },
      '0' => {
               'alt' => 0,
               'state' => 1
             },
      '2' => {
               'state' => 1,
               'alt' => 4
             },
      '21' => {
                'alt' => 0,
                'state' => 0
              },
      '20' => {
                'alt' => 0,
                'state' => 0
              },
      '14' => {
                # alt 4 (ALT0) when Serial bluetooth disabled
                'state' => 1,
                'alt' => 4
              },
      '11' => {
                'alt' => 4,
                'state' => 0
              },

#FIXME: removed due to inherent flipping
#      '12' => {
#                'alt' => 0,
#                'state' => 0
#              },
      '10' => {
                'alt' => 4,
                'state' => 0
              },
              '5' => {
               'alt' => 0,
               'state' => 1
             },
      '9' => {
               'alt' => 4,
               'state' => 0
             },
      '8' => {
               'state' => 1,
               'alt' => 1
             },
      '19' => {
                'alt' => 0,
                'state' => 0
            },
    };

    return $pin_conf;
}
