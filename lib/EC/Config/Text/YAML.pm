package EC::Config::Text::YAML;

use strict;
use warnings;

use Moose;
use namespace::autoclean;
use YAML;

# Class that works with text configs in a YAML format
with 'EC::Config::IStorable::Text';

##############################
# Purpose     : read and parse YAML config file
# Access      : public
# Parameters  : none
# Returns     : EC::Env object or undef
#
sub read {
    my $self = shift;
    
    if ( $self->config_file && ! $self->error ) {
        my $data = eval { YAML::LoadFile($self->config_file); };
        
        if ( $@ ) {
            print STDERR "Failed to read YAML file\n$@\n";
            $self->_set_error(1);
            return undef;
        }
        
        # handled in a base class
        return $data;
    }
    
    return undef;
}

##############################
# Purpose     : save environment to YAML config file
# Access      : public
# Parameters  : config_file (not mandatory)
# Returns     : true or false
#
sub save {
    my ($self, $config_file) = @_;
    
    $config_file ||= $self->config_file;
    
    unless ( $config_file ) {
        print STDERR "Invalid paramter for saving config\n";
        return undef;
    }
    
    my $hash = $self->env->to_hash();
    
    eval { YAML::DumpFile($config_file, $hash); };
    
    if ( $@ ) {
        print STDERR "Failed to dump YAML file\n$@\n";
        $self->_set_error(1);
        return undef;
    }
    
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
