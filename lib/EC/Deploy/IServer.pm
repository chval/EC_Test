package EC::Deploy::IServer;

use strict;
use warnings;

use Moose::Role;
use namespace::autoclean;

# General interface for deployment servers
# this methods must be implemented at inherited classes
requires 'deploy', 'undeploy', 'start', 'stop', 'check';

# environment object
has env => (
    is      => 'rw',
    isa     => 'EC::Env',
);

1;