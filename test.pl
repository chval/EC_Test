#!/usr/bin/perl

use strict;
use TAP::Harness;

my $harness_opts = {
    formatter_class => 'TAP::Formatter::Console',
    lib             => ['lib'],
    verbosity       => 1,
    merge           => 1,
    color           => 1
};

my $harness = TAP::Harness->new($harness_opts);

my $aggregator = $harness->runtests(
    't/Config/Factory.t',
    't/Deploy/Factory.t',
    't/Config/Text/YAML.t',
    't/Config/Text/JSON.t',
);

unless ( $aggregator->all_passed() ) {
    exit 1;
}

exit 0;
