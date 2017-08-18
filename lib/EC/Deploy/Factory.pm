package EC::Deploy::Factory;

use strict;
use warnings;

use EC::Deploy::Server::Tomcat;

# Factory for creating deploy object instances

##############################
# Purpose     : get instance of a EC::Deploy::Server:: class
#                 that will work with appropriate server
# Access      : public
# Parameters  : EC::Env object
# Returns     : EC::Deploy::Server:: object or undef
# Comments    : this is a class method
#
sub get_instance {
    my ($self, $env) = @_;
    
    unless ( $env ) {
        print STDERR "No environment for server detection\n";
        return undef;
    }
        
    # select between different server types
    if ( $env->server eq 'tomcat' ) {
        return EC::Deploy::Server::Tomcat->new(env => $env);
    }
    
    print STDERR "Server class for '" . $env->server . "' is not implemented\n";
    return undef;
}

1;