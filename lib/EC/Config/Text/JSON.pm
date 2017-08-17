package EC::Config::Text::JSON;

use strict;
use warnings;

use Moose;
use namespace::autoclean;
use JSON;
use File::Slurp;

# Class that works with text configs in a JSON format
with 'EC::Config::IStorable::Text';

##############################
# Purpose     : read and parse JSON config file
# Access      : public
# Parameters  : none
# Returns     : EC::Env object or undef
#
sub read {
    my $self = shift;
    
    if ( $self->config_file && ! $self->error ) {
        my $text = File::Slurp::read_file($self->config_file, err_mode => 'carp');
        
        unless ( $text ) {
            print STDERR "Failed to read JSON file\n";
            $self->_set_error(1);
            return undef;
        }
        
        my $json = JSON->new->allow_nonref;
        my $data = eval { $json->decode($text); };
        
        if ( $@ ) {
            print STDERR "Failed to decode JSON text\n$@\n";
            $self->_set_error(1);
            return undef;
        }
        
        # handled in a base class
        return $data;
    }
    
    return undef;
}

##############################
# Purpose     : save environment to JSON config file
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
    my $json = JSON->new->allow_nonref->pretty;
    my $text = $json->encode($hash);
    
    my $status = File::Slurp::write_file($config_file, {err_mode => 'carp'}, $text);
    
    unless ( $status ) {
        $self->_set_error(1);
    }
    
    return $status;
}

__PACKAGE__->meta->make_immutable;

1;
