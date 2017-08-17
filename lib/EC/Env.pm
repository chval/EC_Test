package EC::Env;

use strict;
use warnings;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

# what kind of server is: Tomcat, Glassfish, etc
has server => (
    is      => 'rw',
    isa     => 'Str',
);

# hostname: localhost, 127.0.0.1, etc
has hostname => (
    is      => 'rw',
    isa     => 'Str',
);

# server port on which deployed application should work
has port => (
    is      => 'rw',
    isa     => 'Int',
);

# credentials login
has login => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
);

# credentials password
has password => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
);

# path to .war file to deploy
has archive => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
);

# available actions
enum WebAppActions => ['deploy', 'undeploy', 'start', 'stop', 'check'];

# action what to do
has action => (
    is      => 'rw',
    isa     => 'WebAppActions',
);

##############################
# Purpose     : convert object into hash ref
# Access      : public
# Parameters  : none
# Returns     : hash ref
#
sub to_hash {
    my $self = shift;
    
    my $hash = {};
    
    foreach my $attr ( $self->meta->get_all_attributes() ) {
        
        if ( defined $self->{$attr->name} ) {
            $hash->{$attr->name} = $self->{$attr->name};
        }
    }
    
    return $hash;
}

__PACKAGE__->meta->make_immutable;

1;