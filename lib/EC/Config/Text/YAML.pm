package EC::Config::Text::YAML;

use strict;
use warnings;

use Moose;
use namespace::autoclean;
use YAML;

use EC::Env;

# Class that works with text configs in a YAML format
with 'EC::Config::IStorable::Text';

##############################
# Purpose     : get YAML config file
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
            return;
        }
        
        return EC::Env->new($data);
    }
}

##############################
# Purpose     : save environment to YAML config file
# Access      : public
# Parameters  : EC::Env object
# Returns     : true or false
#
sub save {
    my ($self, $env) = @_;
    
    unless ( $env && ref $env eq 'EC::Env' ) {
        print STDERR "Invalid paramter for saving config\n";
        return;
    }
    
    my $hash = $env->to_hash();
    
    eval { YAML::DumpFile($self->config_file, $hash); };
    
    if ( $@ ) {
        print STDERR "Failed to dump YAML file\n$@\n";
        $self->_set_error(1);
        return;
    }
    
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
