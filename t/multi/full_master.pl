use strict;
use warnings;
use 5.010;

use Data::Dumper;
use RPi::WiringPi;
use Test::More;

my $f = 'ready.multi';

my $pi = RPi::WiringPi->new;

print "\n*** Two pins remote, single pin local ***\n\n";

is exists($pi->metadata->{objects}{$pi->uuid}), 1, "$$ set in meta ok";
is $pi->metadata->{objects}{$pi->uuid}, $$, "UUID set to procID $$ in meta ok";
is keys %{ $pi->metadata->{objects} }, 2, "both procs have registered in meta";

$pi->pin(12);

is exists($pi->metadata->{pins}{12}), 1, "pin 12 exists for master proc ok";
is $pi->metadata->{pins}{12}{users}{$pi->uuid}, 1, "pin 12 has local UUID as user ok";
is exists($pi->metadata->{pins}{18}), 1, "pin 18 exists for slave ok";
is $pi->metadata->{pins}{18}{users}{$pi->uuid}, undef, "pin 18 doesn't have local UUID as user ok";
is exists($pi->metadata->{pins}{26}), 1, "pin 26 exists for slave ok";
is $pi->metadata->{pins}{26}{users}{$pi->uuid}, undef, "pin 26 doesn't have local UUID as user ok";

is keys %{ $pi->metadata->{pins} }, 3, "three pins registered so far ok";

mywait();
unlink $f or die $!;

mywait();
unlink $f or die $!;

print "\n*** External script: Second two pins ***\n\n";

is exists($pi->metadata->{pins}{12}), 1, "pin 12 exists for master proc ok";
is $pi->metadata->{pins}{12}{users}{$pi->uuid}, 1, "pin 12 has local UUID as user ok";
is exists($pi->metadata->{pins}{18}), 1, "pin 18 exists for slave ok";
is $pi->metadata->{pins}{18}{users}{$pi->uuid}, undef, "pin 18 doesn't have local UUID as user ok";
is exists($pi->metadata->{pins}{26}), 1, "pin 26 exists for slave ok";
is $pi->metadata->{pins}{26}{users}{$pi->uuid}, undef, "pin 26 doesn't have local UUID as user ok";
is exists($pi->metadata->{pins}{21}), 1, "pin 21 exists for slave ok";
is $pi->metadata->{pins}{21}{users}{$pi->uuid}, undef, "pin 21 doesn't have local UUID as user ok";
is exists($pi->metadata->{pins}{16}), 1, "pin 16 exists for slave ok";
is $pi->metadata->{pins}{16}{users}{$pi->uuid}, undef, "pin 16 doesn't have local UUID as user ok";

is keys %{ $pi->metadata->{pins} }, 5, "now have five pins registered";

sleep 2;

print "\n*** External script: Cleaned up ***\n\n";

is exists($pi->metadata->{objects}{$pi->uuid}), 1, "$$ set in meta ok";
is $pi->metadata->{objects}{$pi->uuid}, $$, "UUID set to procID $$ in meta ok";
is keys %{ $pi->metadata->{objects} }, 1, "the remote proc UUID is now removed from shared mem";

is exists($pi->metadata->{pins}{12}), 1, "pin 12 exists for master proc ok";
is $pi->metadata->{pins}{12}{users}{$pi->uuid}, 1, "pin 12 has local UUID as user ok";
is exists($pi->metadata->{pins}{18}), '', "pin 18 is gone";
is exists($pi->metadata->{pins}{26}), '', "pin 26 is gone";
is exists($pi->metadata->{pins}{21}), '', "pin 21 is gone";
is exists($pi->metadata->{pins}{16}), '', "pin 16 is gone";

is keys %{ $pi->metadata->{pins} }, 1, "back to only one pin registered";

$pi->cleanup;

print "\n*** Local: Cleaned up ***\n\n";

is keys %{ $pi->metadata->{objects} }, 0, "all objects have been removed from registry";
is keys %{ $pi->metadata->{pins} }, 0, "all pins have been removed from registry";

done_testing();

sub mywait {
    while (1){
        last if -e $f;
        select(undef, undef, undef, 0.2);
    }
}
