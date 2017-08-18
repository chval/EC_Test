# EC_Test
Electric Cloud - PERL test

1. Download source code with `git clone` to your favourite directory

2. Go to directory with a source code, export some env variables and run tests
```
export PERL5LIB=lib
perl test.pl
```

3. You can use Docker for quicker test
```
docker-compose run ectest bash

perl test.pl

# deploy app and save config
perl mod_control.pl --hostname=tomcat8 --port=8080 --archive=/tmp/sample.war --webpath=/sample --action deploy --login tommy --password=thecat --save --config=mytom.json

# check app
perl mod_control.pl --config=mytom.json --action check
```

3. Run tool

```
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
 ```
 
 Examples:
 
 - Deploy web archive to TOMCAT server and save a configuration to .yaml file
 ```
 perl mod_control.pl --server=localhost --port=8080 --login=foo --password=bar --archive=sample.war --webpath=/sample --action=deploy --save --config=mytom.yaml
 ```
 
 - Now you can use your config to check if application is running
  ```
 perl mod_control.pl --action=check --config=mytom.yaml
 ```
 
  - Also you can overwrite any options and save it again, if you dont want to save credentials
  ```
 perl mod_control.pl --server=localhost --port=8080 --archive=sample.war --webpath=/sample --save --config=mytom.json
 perl mod_control.pl --config=mytom.json --login=foo --password=bar
 ```