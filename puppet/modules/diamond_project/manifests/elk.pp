# == Class: diamond_project::elk
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
class diamond_project::elk (
  $kato_port        = hiera('diamond_project::elk::kato_port'       , '10002'),
  $stackatoapp_port = hiera('diamond_project::elk::stackatoapp_port', '10001'),
  $redis_server     = hiera('diamond_project::elk::redis_server'    , 'localhost'),
  $redis_port       = hiera('diamond_project::elk::redis_port'      , '6379'),
  $ls_home          = hiera('diamond_project::elk::ls_home'         , '/mnt/logstash'),
) {
  class { 'elasticsearch':
    java_install => true,
    package_url  => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.deb',
    config       => {
                    'http.cors.enabled'      => true,
                    'http.cors.allow-origin' => '"/.*/"',
                    },
  } ->
  elasticsearch::instance { 'es-01': }

  #version => '1.4.2',
  class { 'logstash':
    package_url   => 'https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb',
    init_defaults => {
      'LS_USER'  => 'logstash',
      'LS_GROUP' => 'logstash',
      'LS_HOME'  => $ls_home,
    },
  } ->
  file { $ls_home:
    ensure => 'directory',
    mode   => '0664',
    owner  => 'logstash',
    group  => 'logstash',
  } ->
  logstash::plugin { 'grep':
    ensure   => 'present',
    type     => 'filter',
    source   => 'puppet:///modules/diamond_project/logstash/grep.rb',
    filename => 'grep.rb',
  }

  logstash::configfile { 'syslog.conf':
    content => template('diamond_project/logstash/syslog.conf.erb'),
    order   => 10,
  }

  class { 'kibana3':
    manage_git => false,
    manage_ws  => false, #skip apache because maestro's old version
    k3_release => '07bbd7e', #3.1.2
  }
  #kibana3 module is incompatible with current version of apache in maestro
  include apache
  apache::vhost { 'kibana3' :
    port      => '80',
    docroot   => "${::kibana3::k3_install_folder}/src",
    priority  => '10',
    template  => 'diamond_project/kibana/kibana.vhost.erb',
    subscribe => File["${::kibana3::k3_install_folder}/src/config.js"],
  }

  #firewall { '10 ELK kit ports':
  #  chain  => 'INPUT',
  #  state  => 'NEW',
  #  action => 'accept',
  #  proto  => 'tcp',
  #  sport  => ['5000', '9200', '9300', $stackatoapp_port, $kato_port],
  #  source => '0.0.0.0/0',
  #}

}