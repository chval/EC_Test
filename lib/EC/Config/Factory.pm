package EC::Config::Factory;

use strict;
use warnings;

use EC::Config::Text::YAML;

# Factory for creating config object instances

##############################
# Purpose     : get instance of a EC::Config:: class
#                 that will work with passed parameters
# Access      : public
# Parameters  : config_file
# Returns     : EC::Config:: object or undef
# Comments    : this is a class method
#
sub get_instance {
    my ($self, $config_file) = @_;
    
    unless ( $config_file ) {
        print STDERR "config_file is a mandatory parameter\n";
        return;
    }

    if ( $config_file =~ /\.yaml$/ ) {
        return EC::Config::Text::YAML->new($config_file);
    }

    print STDERR "Config class for $config_file is not implemented\n";
    return;
}

1;