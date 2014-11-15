# == Class: diamond_project::jenkins
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
class diamond_project::jenkins (
  $jenkins_port = '8081',
  $default_user = 'jenkins',
  $default_pass = 'changeme',
){

  #Workaround to load settings before first run
  file { '/var/lib/jenkins/config.xml' :
    ensure    => 'present',
    owner     => 'jenkins',
    group     => 'jenkins',
    mode      => '0644',
    content   => template('diamond_project/jenkins/config.xml.erb'),
    subscribe => File['/var/lib/jenkins'],
  }

  class { '::jenkins':
    lts          => true,
    install_java => true,
    cli          => true,
    config_hash  => {
                    'HTTP_PORT' => {
                                  'value' => $jenkins_port
                    }
    },
  }

  jenkins_config::plugin { 'git': } ->
  jenkins_config::plugin { 'git-client': } ->
  jenkins_config::plugin { 'scm-api': } ->
  jenkins_config::plugin { 'gitlab-plugin': } ->
  jenkins_config::plugin { 'gitlab-merge-request-jenkins': } ->

  exec { 'wait for Jenkins to be ready':
    command   => "wget --spider http://127.0.0.1:${jenkins_port}",
    path      => '/usr/local/bin:/usr/bin:/bin',
    timeout   => 30,
    tries     => 20,
    try_sleep => 10,
    subscribe => Class['::jenkins::service'],
    unless    => "wget --spider http://127.0.0.1:${jenkins_port}",
  }

  ::jenkins::user { $default_user:
    email    => "${default_user}@forj.io",
    password => $default_pass,
    require  => Exec['wait for Jenkins to be ready'],
  }

#    plugin_hash  => {
#    'gitlab-plugin' => { 'version' => 0, },
#    'gitlab-merge-request-jenkins' => { 'version' => '1.2.2', },
#  },
}
