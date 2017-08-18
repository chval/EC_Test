package t::Config::Text::JSON;

use strict;
use warnings;

use Test::Builder;

use EC::Config::Text::JSON;

my $builder = Test::Builder->new();

$builder->subtest('Read config from .json' => sub {
    my $config = EC::Config::Text::JSON->new('t/config.json');
    my $env = $config->read();
    
    $builder->is_eq(ref $env, 'EC::Env', 'Env object create');
    $builder->is_num($env->port, 8888, 'Port correct');
});

$builder->subtest('Read config from .json and overwrite variable' => sub {
    my $config = EC::Config::Text::JSON->new('t/config.json');
    my $env = $config->read(port => 8080);
    
    $builder->is_eq(ref $env, 'EC::Env', 'Env object create');
    $builder->is_num($env->port, 8080, 'Port overwritten');
});

$builder->done_testing();
