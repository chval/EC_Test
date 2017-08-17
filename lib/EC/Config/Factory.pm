package EC::Config::Factory;

use strict;
use warnings;

use EC::Config::Text::YAML;
use EC::Config::Text::JSON;
use EC::Config::CmdLine;

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
    my $self = shift;
    
    # instance can be received from config file or from options hash
    my $config_file;
    my %opts = ();
    
    unless ( @_ ) {
        return undef;
    }
    
    unless ( scalar @_ % 2 ) {
        
        # even number of params
        %opts = @_;
    } else {
        $config_file = shift;
    }
    
    if ( $config_file ) {
        
        # select between different config file types
        if ( $config_file =~ /\.yaml$/ ) {
            return EC::Config::Text::YAML->new($config_file);
        } elsif ( $config_file =~ /\.json$/ ) {
            return EC::Config::Text::JSON->new($config_file);
        }
        
        print STDERR "Config class for $config_file is not implemented\n";
        return undef;
    }
    
    return EC::Config::CmdLine->new(%opts);
}

1;