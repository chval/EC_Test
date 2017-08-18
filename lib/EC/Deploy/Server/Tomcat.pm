package EC::Deploy::Server::Tomcat;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

use EC::Deploy::Protocol::HTTP;

# HTTP protocol object helper
has http => (
    is      => 'ro',
    isa     => 'EC::Deploy::Protocol::HTTP',
    writer  => '_set_http'
);

# Class that can deploy application to a Tomcat server
with 'EC::Deploy::IServer';

##############################
# Purpose     : initialize object
# Access      : public
# Parameters  : hash ref with params
# Returns     : none
# Comments    : method is called after an object is created
#
sub BUILD {
    my $self = shift;
    
    $self->_set_http(EC::Deploy::Protocol::HTTP->new());
}

##############################
# Purpose     : build base url for Tomcat manager api
# Access      : private
# Parameters  : none
# Returns     : base server url
#
sub _build_base_url {
    my $self = shift;
    
    return 'http://' .
        $self->env->hostname . ':' . $self->env->port . '/manager/text/';
}

##############################
# Purpose     : deploy archive to Tomcat server
# Access      : public
# Parameters  : none
# Returns     : true or false
#
sub deploy {
    my $self = shift;
    
    my $url = $self->_build_base_url() . 'deploy?update=true&path=' . $self->env->webpath;
    
    my $resp = $self->http->put($url,
        file        => $self->env->archive,
        login       => $self->env->login,
        password    => $self->env->password
    );
    
    if ( $resp && $resp->is_success ) {
        return 1;
    }
    
    return undef;
}

##############################
# Purpose     : undeploy archive from Tomcat server
# Access      : public
# Parameters  : none
# Returns     : true or false
#
sub undeploy {
    my $self = shift;
    
    my $url = $self->_build_base_url() . 'undeploy?path=' . $self->env->webpath;
    
    my $resp = $self->http->get($url,
        login       => $self->env->login,
        password    => $self->env->password
    );
    
    if ( $resp && $resp->is_success ) {
        return 1;
    }
    
    return undef;
}

##############################
# Purpose     : start deployed archive on a Tomcat server
# Access      : public
# Parameters  : none
# Returns     : true or false
#
sub start {
    my $self = shift;
    
    my $url = $self->_build_base_url() . 'start?path=' . $self->env->webpath;
    
    my $resp = $self->http->get($url,
        login       => $self->env->login,
        password    => $self->env->password
    );
    
    if ( $resp && $resp->is_success ) {
        return 1;
    }
    
    return undef;
}

##############################
# Purpose     : stop deployed archive on a Tomcat server
# Access      : public
# Parameters  : none
# Returns     : true or false
#
sub stop {
    my $self = shift;
    
    my $url = $self->_build_base_url() . 'stop?path=' . $self->env->webpath;
    
    my $resp = $self->http->get($url,
        login       => $self->env->login,
        password    => $self->env->password
    );
    
    if ( $resp && $resp->is_success ) {
        return 1;
    }
    
    return undef;
}

##############################
# Purpose     : check if application running on a Tomcat server
# Access      : public
# Parameters  : none
# Returns     : true or false
#
sub check {
    my $self = shift;
    
    my $url = 'http://' .
        $self->env->hostname . ':' . $self->env->port . $self->env->webpath;
    
    my $resp = $self->http->get($url,
        login       => $self->env->login,
        password    => $self->env->password
    );
    
    if ( $resp && $resp->is_success ) {
        return 1;
    }
    
    return undef;
}

__PACKAGE__->meta->make_immutable;

1;