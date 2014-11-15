# == Class: diamond_project::gitlab
# Copyright 2014 Hewlett-Packard Development Company, L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
class diamond_project::gitlab(
  $git_email     = 'gitlab@forj.io',
  $git_comment   = 'GitLab',
  $gitlab_domain = 'gitlab.forj.io',
  $gitlab_dbtype = 'mysql',
  $gitlab_dbname = 'gitlabdb',
  $gitlab_dbuser = 'gitlab',
  $gitlab_dbpwd  = 'changeme',
){

  require nginx
  require redis
  require mysql::server

  mysql::db { $gitlab_dbname:
    user     => $gitlab_dbuser,
    password => $gitlab_dbpwd,
    host     => 'localhost',
    grant    => ['ALL'],
  }

  #Installs or update to ruby 1.9 'ruby1.9.1-dev'
  class { 'ruby':
    ruby_package     => 'ruby1.9.1-full',
    rubygems_package => 'rubygems1.9.1',
    gems_version     => 'latest',
  } ->
  package { ['cmake', 'pkg-config']:
    ensure => installed,
  } ->
  class { '::gitlab':
    gitlab_branch      => '7-4-stable',
    gitlabshell_branch => 'v2.0.1',
    git_email          => $git_email,
    git_comment        => $git_comment,
    gitlab_domain      => $gitlab_domain,
    gitlab_dbtype      => $gitlab_dbtype,
    gitlab_dbname      => $gitlab_dbname,
    gitlab_dbuser      => $gitlab_dbuser,
    gitlab_dbpwd       => $gitlab_dbpwd,
    ldap_enabled       => false,
    require            => Mysql::Db[$gitlab_dbname],
    notify             => Class['nginx::service'],
  }

}
