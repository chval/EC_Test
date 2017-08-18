package EC::Config::IStorable;

use strict;
use warnings;

use Moose::Role;
use namespace::autoclean;
use Try::Tiny;

use EC::Env;

# General interface for storable configuration
# this methods must be implemented at inherited classes
requires 'read', 'save';

# flag if some error happened during object work
has error => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
    writer  => '_set_error'
);

# parsed environment object
has env => (
    is      => 'ro',
    isa     => 'EC::Env',
    writer  => '_set_env'
);

# always set env after reading config
around 'read' => sub {
    my $orig = shift;
    my $self = shift;
    
    # try to read from default source
    my $data = $self->$orig() || {};
    
    if ( @_ && (! scalar @_ % 2) ) {
        
        # additional options must be set or overwrite present
        my %opts = @_;
        
        if ( ref $data eq 'HASH' ) {
            
            foreach my $key ( keys %opts ) {
                $data->{$key} = $opts{$key};
            }
        }
    }
    
    if ( $data ) {
        
        try {
            my $env = EC::Env->new($data);
            $self->_set_env($env);
            return $env;
        } catch {
            my $e = $_;
            
            if (
                blessed $e
                && $e->isa('Moose::Exception')
            ) {
                my $attr_name = $e->attribute_name;
        
                print STDERR "Invalid attribute '$attr_name' value!\n";
            } else {
                print STDERR "$e\n";
            }
            
            return undef;
        }
    }
};

1;
