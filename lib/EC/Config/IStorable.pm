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

# parsed environment object
has env => (
    is      => 'ro',
    isa     => 'EC::Env',
    writer  => '_set_env'
);

# always set env after reading config
around 'read' => sub {
    my $orig = shift;
    my $self = shift;
    
    my $env = $self->$orig(@_);
    
    unless ( $self->error ) {
        $self->_set_env($env);
    }
};

1;
