package EC::Config::IStorable::Text;

use strict;
use warnings;

use Moose::Role;
use namespace::autoclean;

# General interface for text config files
# Inherits general storable config interface
with 'EC::Config::IStorable';

# path to a config filename on a disk
has config_file => (
    is      => 'rw',
    isa     => 'Str',
    writer  => '_set_config_file'
);

##############################
# Purpose     : allows pass to constructor just config_filename argument
# Access      : class method
# Parameters  : hash of params or config_filename
# Returns     : hash of params
# Comments    : method is called as a class method before an object is created
#
around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    
    if ( @_ == 1 ) {
        
        # looks like config filename
        my $config_file = $_[0];
        
        return $class->$orig(
            config_file => $config_file,
        );
    }
    
    return $class->$orig();
};

##############################
# Purpose     : initialize object
# Access      : public
# Parameters  : hash ref with params
# Returns     : none
# Comments    : method is called after an object is created
#
sub BUILD {
    my $self = shift;
    
    if ( $self->config_file ) {
        
        unless ( -f $self->config_file ) {
            #print STDERR "No such file: " . $self->config_file . "\n";
            $self->_set_error(1);
        }
    }
}

1;