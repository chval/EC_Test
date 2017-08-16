package EC::Config::IStorable;

use strict;
use warnings;

use Moose::Role;
use namespace::autoclean;

# General interface for storable configuration
# this methods must be implemented at inherited classes
requires 'read', 'save';

# flag if some error happened during object work
has error => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
    writer  => '_set_error'
);

1;
