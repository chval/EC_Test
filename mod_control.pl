#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

use EC::Config::Factory;
use EC::Deploy::Factory;

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
my $webpath;

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
    'webpath=s'     => \&deploy_options_handler,
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

my $deployer = EC::Deploy::Factory->get_instance($env);

unless ( $deployer ) {
    exit 1;
}

# do required action
my $_action = $env->action;
$deployer->$_action();

if ( $save && $config_file ) {
    $config->save($config_file) || exit 1;
}

exit 0;

__DATA__
mod_control.pl version 0.1

Usage: mod_control.pl [options] ...
Tool for control web archive application: saving/deleting of the configuration,
deploy/undeploy of an application, start/stop of the application, check deployed application.

 -h, --help         Print this help message
 -c, --config       Load configuration from a file (.json or .yaml)
 -s, --save         Save command line deploy options to a file (--config must be specified)
 
 Deploy options
 --server           Server type: tomcat by default
 --hostname         Hostname where to deploy (localhost by default)
 --port             Host port (8080 by default)
 --login            Deploy username credential
 --password         Deploy password credential
 --archive          Path to a host .war file
 --action           What action to do on a server: deploy, undeploy, start, stop, check (check by default)
 --webpath          At what web path deployed application will be available (/sample by default)
