package EC::Deploy::Protocol::HTTP;

use strict;
use warnings;

use Moose;
use namespace::autoclean;

use LWP::UserAgent;
use HTTP::Request;

##############################
# Purpose     : prepare http request for web server
# Access      : private
# Parameters  : sending method (GET, PUT, POST, DELETE)
#             : server url
#             : hash with additional options
#             :   data  - to send (will be encoded to json)
# Returns     : HTTP::Request object or undef
#
sub _create_request {
    my ($self, $method, $url) = (shift, shift, shift);
    
    unless ( $method && $url ) {
        print STDERR "Request method and URL are mandatory for creating http request\n";
        return undef;
    }
    
    my %opts = ();
    
    unless ( scalar @_ % 2 ) {
        
        # even number of params
        %opts = @_;
    } else {
        print STDERR "Odd number of parameters\n";
        return undef;
    }
    
    print "$method => $url\n";
    my $req = HTTP::Request->new($method => $url);
    
    if ( $opts{login} ) {
        $req->authorization_basic($opts{login}, $opts{password});
    }
    
    if ( $opts{data} ) {
        my $data = $opts{data};
        my $content;
        
        if ( ref $data eq 'HASH' || ref $data eq 'ARRAY' ) {
            print "Encode data to JSON\n";
            my $json = JSON->new->utf8;
            $content = $json->encode($data);
            $req->header('content-type' => 'application/json');
        } else {
            $content = $data;
        }
        
        print "SEND: $content\n";
        $req->content($content);
    } elsif ( $opts{file} ) {
        my $file = $opts{file};
        
        if ( -f $file && open(my $fh, '<', $file) ) {
            (my $filename = $file) =~ s/^.*\///;
            print "SEND: filename='$filename'\n";
            $req->header('Content-Disposition' => "form-data; name='war'; filename='$filename'");
            $req->header('Content-Type' => 'application/octet-stream');
            
            while ( <$fh> ) {
                $req->add_content($_);
            }
            
            close $fh;
        } else {
            print STDERR "File $file doesn't exist or cant be read\n";
        }
    } else {
        #print "No data in request\n";
    }
        
    return $req;
}

##############################
# Purpose     : send http request to web server
# Access      : private
# Parameters  : HTTP::Request object
# Returns     : HTTP::Response object or undef
#
sub _send_request {
    my ($self, $req) = @_;
    
    unless ( $req && ref $req eq 'HTTP::Request' ) {
        print STDERR "HTTP::Request object required for sending http request\n";
        return undef;
    }
    
    my $ua = LWP::UserAgent->new;
    my $res = $ua->request($req);
        
    if ( $res->is_success ) {
        print "RECV: ", $res->decoded_content, "\n";
    } else {
        print STDERR $res->status_line, "\n";
    }
    
    return $res;
}

##############################
# Purpose     : send GET request to web server
# Access      : public
# Parameters  : server url
#             : hash with options ( for _create_request method)
# Returns     : HTTP::Response object or undef
#
sub get {
    my ($self, $url, %opts) = @_;
    
    return $self->_send_request($self->_create_request('GET', $url, %opts));
}

##############################
# Purpose     : send POST request to web server
# Access      : public
# Parameters  : server url
#             : hash with options ( for _create_request method)
# Returns     : HTTP::Response object or undef
#
sub post {
    my ($self, $url, %opts) = @_;
    
    return $self->_send_request($self->_create_request('POST', $url, %opts));
}

##############################
# Purpose     : send PUT request to web server
# Access      : public
# Parameters  : server url
#             : hash with options ( for _create_request method)
# Returns     : HTTP::Response object or undef
#
sub put {
    my ($self, $url, %opts) =@_;
    
    return $self->_send_request($self->_create_request('PUT', $url, %opts));
}

##############################
# Purpose     : send DELETE request to web server
# Access      : public
# Parameters  : server url
#             : hash with options ( for _create_request method)
# Returns     : HTTP::Response object or undef
#
sub delete {
    my ($self, $url, %opts) =@_;
    
    return $self->_send_request($self->_create_request('DELETE', $url, %opts));
}

##############################
# Purpose     : decode json response
# Access      : public
# Parameters  : HTTP::Response object
# Returns     : hashref with json content
#
sub get_content {
    my ($self, $res) = @_;
    
    my $json = JSON->new->utf8;
    my $content = eval { $json->decode($res->content); };
    
    if ( $@ ) {
        print STDERR "Failed to decode response content\n";
        return undef;
    } 
    return $content;
}

__PACKAGE__->meta->make_immutable;

1;
