# Class: java::v7
# This module is modified from https://github.com/softek/puppet-java7
#
# This module manages Oracle Java7 for ubuntu and debian
# and openJDK 1.7 for CentOS
#
# Parameters: none
# Requires:
#  apt
# Sample Usage:
#  include java:v7
#
class java::v7 {
  include java::params

  case $::operatingsystem {
    debian: {
      include apt
      
      apt::source { 'webupd8team': 
        location          => "http://ppa.launchpad.net/webupd8team/java/ubuntu",
        release           => "precise",
        repos             => "main",
        key               => "EEA14886",
        key_server        => "keyserver.ubuntu.com",
        include_src       => true
      }
      package { 'oracle-java7-installer':
        responsefile => '/tmp/java.preseed',
        require      => [
                          Apt::Source['webupd8team'],
                          File['/tmp/java.preseed']
                        ],
      }
   }
   ubuntu: {
     include apt

      apt::ppa { 'ppa:webupd8team/java': }
      package { 'oracle-java7-installer':
        responsefile => '/tmp/java.preseed',
        require      => [
                          Apt::Ppa['ppa:webupd8team/java'],
                          File['/tmp/java.preseed']
                        ],
      }
   }

   CentOS: {
     package { "java-1.7.0-openjdk-devel":
        alias => "java-1.7.0-openjdk-devel",
        ensure => present,
     } ->

     file { "/etc/profile.d/java_home.sh":
        ensure  => present,
        content => "export JAVA_HOME='/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'",
     }
   }

   default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
 }

  case $::operatingsystem {
    debian, ubuntu: {
      file { '/tmp/java.preseed':
        source => 'puppet:///modules/java/java.preseed',
        mode   => '0600',
        backup => false,
      }
    }
  }
}
