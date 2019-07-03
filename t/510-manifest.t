use 5.006;
use strict;
use warnings;

use lib 't/';

use RPiTest qw(check_pin_status running_test);
use Test::More;

unless ( $ENV{RPI_RELEASE_TESTING} ) {
    plan( skip_all => "Author test: RPI_RELEASE_TESTING not set" );
}

my $min_tcm = 0.9;
eval "use Test::CheckManifest $min_tcm";
plan skip_all => "Test::CheckManifest $min_tcm required" if $@;

running_test(__FILE__);

ok_manifest();
