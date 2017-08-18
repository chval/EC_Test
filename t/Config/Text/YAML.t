package t::Config::Text::YAML;

use strict;
use warnings;

use Test::Builder;

use EC::Config::Text::YAML;

my $builder = Test::Builder->new();

$builder->subtest('Read config from .yaml' => sub {
    my $config = EC::Config::Text::YAML->new('t/config.yaml');
    my $env = $config->read();
    
    $builder->is_eq(ref $env, 'EC::Env', 'Env object create');
    $builder->is_eq($env->login, 'foo', 'Login correct');
});

$builder->subtest('Read config from .yaml and overwrite variable' => sub {
    my $config = EC::Config::Text::YAML->new('t/config.yaml');
    my $env = $config->read(login => 'bar');
    
    $builder->is_eq(ref $env, 'EC::Env', 'Env object create');
    $builder->is_eq($env->login, 'bar', 'Login correct');
});

$builder->done_testing();
