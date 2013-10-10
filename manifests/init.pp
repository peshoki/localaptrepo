# Class: localaptrepo
#
# This module manages localaptrepo
#
# Parameters: 
# $deburls list of packages that need to be downloaded.
# $repopath where to store repo '/tmp/pupetrepo' 
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class localaptrepo (
  $deburls = [],
  $repopath = '/tmp/pupetrepo' 
) {
  
   
   $sources_list_content =  "deb file:$repopath ./"
   $sources_list_filename = 'puppetlocal.list'
   
   
  class init {
        
    file { "/etc/apt/sources.list.d/$::localaptrepo::sources_list_filename":
      ensure => file,
      content => $::localaptrepo::sources_list_content 
    }

    file { $::localaptrepo::repopath:
      ensure => directory,
    }
    
     

    package { 'dpkg-dev':
        ensure   => 'latest',
        provider => apt,
        before => Exec["createindex"],
    }

    define downloaddebs {
      exec { $title:
        cwd  => $::localaptrepo::repopath,
        command => "/usr/bin/wget -nc $title",
      }
    }
    
    downloaddebs {
      $::localaptrepo::deburls:
    }
    
    exec { "createindex":
      cwd  => $::localaptrepo::repopath,
      command => '/usr/bin/dpkg-scanpackages . /dev/null > Packages ',
      require => Downloaddebs[$::localaptrepo::deburls],
      before => Exec["apt-get update"]
    }
    
    exec { "apt-get update":
      command => "/usr/bin/apt-get update",
    }       
  }     
}