package EC::Env;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

has hostname => (
    is      => 'rw',
    isa     => 'Str',
);

has login => (
    is      => 'rw',
    isa     => 'Str',
);

has password => (
    is      => 'rw',
    isa     => 'Str',
);

##############################
# Purpose     : allows pass to constructor any hash reference
# Access      : class method
# Parameters  : hash of params or a reference
# Returns     : hash of params
# Comments    : method is called as a class method before an object is created
#
around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    
    if ( @_ == 1 && ref $_[0] eq 'HASH' ) {
        
        # looks like hash with variables
        my %opts = ();
        
        foreach my $attr ( keys %{$_[0]} ) {
            
            if ( $class->can($attr) ) {
                $opts{$attr} = $_[0]{$attr};
            } else {
                print STDERR "Env has no such attribute: $attr\n";
            }
        }
        
        return $class->$orig(%opts);
    }
    
    return $class->$orig();
};

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
        $hash->{$attr->name} = $self->{$attr->name};
    }
    
    return $hash;
}

__PACKAGE__->meta->make_immutable;

1;