package EC::Deploy::Server::Tomcat;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

use EC::Deploy::Protocol::HTTP;

# Class that can deploy application to a Tomcat server
with 'EC::Deploy::IServer';

##############################
# Purpose     : build base url for Tomcat manager api
# Access      : private
# Parameters  : none
# Returns     : base server url
#
sub _build_base_url {
    my $self = shift;
    
    return 'http://' . $self->env->hostname . ':' . $self->env->port . '/manager/text/';
}

sub deploy {
    my $self = shift;
    
    my $url = $self->_build_base_url() . 'deploy';
    
    my $http = EC::Deploy::Protocol::HTTP->new();
    $http->put($url, data => $self->env->archive);
}

sub undeploy {
    my $self = shift;
}

sub start {
    my $self = shift;
}

sub stop {
    my $self = shift;
}

sub check {
    my $self = shift;
}

__PACKAGE__->meta->make_immutable;

1;