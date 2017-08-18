package t::Deploy::Factory;

use strict;
use warnings;

use Test::Builder;

use EC::Env;
use EC::Deploy::Factory;

my $builder = Test::Builder->new();

$builder->subtest('Create deploy object for Tomcat server' => sub {
    
    my $env = EC::Env->new(server => 'tomcat');
    my $deploy = EC::Deploy::Factory->get_instance($env);
    
    $builder->is_eq(ref $deploy, 'EC::Deploy::Server::Tomcat', 'Object create');
});

$builder->subtest('Create deploy object for Jetty server' => sub {
    
    my $env = EC::Env->new(server => 'jetty');
    my $deploy = EC::Deploy::Factory->get_instance($env);
    
    $builder->is_eq($deploy, undef, 'Object was not created');
});

$builder->subtest('Create deploy object from nothing' => sub {
    
    my $deploy = EC::Deploy::Factory->get_instance();
    
    $builder->is_eq($deploy, undef, 'Object was not created');
});

$builder->done_testing();
