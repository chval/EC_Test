package EC::Config::CmdLine;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

use EC::Config::Factory;

# Class that works with command line options
# Inherits general storable config interface
with 'EC::Config::IStorable';

##############################
# Purpose     : simulate reading command line options
# Access      : public
# Parameters  : none
# Returns     : EC::Env object or undef
#
sub read {
    my $self = shift;
    
    # handled in a base class
    return {};
}

##############################
# Purpose     : save environment to appropriate config file
# Access      : public
# Parameters  : config_file
# Returns     : true or false
#
sub save {
    my ($self, $config_file) = @_;
    
    unless ( $config_file ) {
        print STDERR "Invalid paramter for saving config\n";
        return undef;
    }
    
    # get appropriate config object by config_file
    my $config = EC::Config::Factory->get_instance($config_file);
    
    # init with environment to save
    $config->read($self->env);
    
    if ( $config ) {
        return $config->save();
    }
    
    return undef;
}

__PACKAGE__->meta->make_immutable;

1;
