#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

use EC::Config::Factory;

# tool options
my $help;

# config filename with options
my $config_file;

# options that overwrite config variables
my $hostname;
my $login;
my $password;
my $app_archive;
my $action;

GetOptions(
    'h|help'        => \$help,
    'c|config=s'    => \$config_file
);

if ( $help ) {
    while ( <DATA> ) { print }
    exit 0;
}

if ( $config_file ) {

    # try to read config file
    my $config = EC::Config::Factory->get_instance($config_file);
    
    unless ( $config ) {
        exit 1;
    }

    my $env = $config->read();
}

__DATA__
mod_control.pl version 0.1

Usage: mod_control.pl [options] ...
Tool for control web archive application: saving/deleting of the configuration,
deploy/undeploy of an application, start/stop of the application, check deployed application.

 -h, --help         Print this help message
