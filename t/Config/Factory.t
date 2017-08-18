package t::Config::Factory;

use strict;
use warnings;

use Test::Builder;

use EC::Config::Factory;

my $builder = Test::Builder->new();

$builder->subtest('Create config object from .yaml file' => sub {
    
    my $config = EC::Config::Factory->get_instance('AconfigA.yaml');
    
    $builder->is_eq(ref $config, 'EC::Config::Text::YAML', 'Object create');
    $builder->is_num($config->error, 1, 'Config file doesnt exist');
});

$builder->subtest('Create config object from .json file' => sub {
    
    my $config = EC::Config::Factory->get_instance('BconfigB.json');
    
    $builder->is_eq(ref $config, 'EC::Config::Text::JSON', 'Object create');
    $builder->is_num($config->error, 1, 'Config file doesnt exist');
});

$builder->subtest('Create config object from .xml file' => sub {
    
    my $config = EC::Config::Factory->get_instance('CconfigC.xml');
    
    $builder->is_eq($config, undef, 'Object was not created');
});

$builder->subtest('Create config object from env variables' => sub {
    
    my $config = EC::Config::Factory->get_instance(server => 'localhost', port => 8080);
    
    $builder->is_eq(ref $config, 'EC::Config::CmdLine', 'Object create');
    $builder->is_num($config->error, 0, 'No errors in config');
});

$builder->subtest('Create config object from nothing' => sub {
    
    my $config = EC::Config::Factory->get_instance();
    
    $builder->is_eq($config, undef, 'Object was not created');
});

$builder->done_testing();
