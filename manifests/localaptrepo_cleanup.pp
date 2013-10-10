# Class: localaptrepo_cleanup

class localaptrepo_cleanup () {
    file   { "/etc/apt/sources.list.d/$::localaptrepo::sources_list_filename":
      ensure => absent,
      before => Exec["apt-get update"] 
    }

    file   { $::localaptrepo::repopath:
      ensure => absent,
      recurse => true,
    }
    
    exec { "apt-get update":
      command => "/usr/bin/apt-get update",
    }             
  } 