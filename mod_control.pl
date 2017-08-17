#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

use EC::Env;
use EC::Config::Factory;

# tool options
my $help;

# config filename with options
my $config_file;
my $save;

# options that overwrite config variables
my $server;
my $hostname;
my $port;
my $login;
my $password;
my $archive;
my $action;

GetOptions(
    'h|help'        => \$help,
    'c|config=s'    => \$config_file,
    's|save'        => \$save,
    'server=s'      => \&deploy_options_handler,
    'hostname=s'    => \&deploy_options_handler,
    'port=i'        => \&deploy_options_handler,
    'login=s'       => \&deploy_options_handler,
    'password=s'    => \&deploy_options_handler,
    'archive=s'     => \&deploy_options_handler,
    'action=s'      => \&deploy_options_handler,
);

# deploy environment options
our %env_opts;

# deploy options handler
sub deploy_options_handler {
    my ($opt_name, $opt_value) = @_;
    
    if ( defined $opt_value ) {
        $env_opts{$opt_name} = $opt_value;
    }
}

# ---

if ( $help
    || (! keys %env_opts && ! $config_file)
) {
    while ( <DATA> ) { print }
    exit 0;
}

# init module config object from config file or env variables
my $config = EC::Config::Factory->get_instance($config_file || %env_opts);

unless ( $config ) {
    exit 1;
}

# read and parse config
my $env = $config->read(%env_opts);

unless ( $env ) {
    exit 1;
}

use EC::Deploy::Server::Tomcat;
my $tom = EC::Deploy::Server::Tomcat->new(env => $env);
$tom->deploy();

if ( $save && $config_file ) {
    $config->save($config_file);
}

__DATA__
mod_control.pl version 0.1

Usage: mod_control.pl [options] ...
Tool for control web archive application: saving/deleting of the configuration,
deploy/undeploy of an application, start/stop of the application, check deployed application.

 -h, --help         Print this help message
