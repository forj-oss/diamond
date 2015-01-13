# == Class: diamond_project::openfire
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
class diamond_project::openfire (
  $of_admin_pass = hiera('diamond_project::openfire::of_admin_pass', 'changeme'),
  $of_plugins    = hiera('diamond_project::openfire::of_plugins'   , ['monitoring.jar']),
  $of_hubot_pass = hiera('diamond_project::openfire::of_hubot_pass', 'changeme'),
){
  $fqdn = $::fqdn ? {
    ''      => '127.0.0.1',
    default => $::fqdn,
  }

  class { '::openfire':
    install_java  => false,
    of_admin_pass => $of_admin_pass,
    of_config     => {
      'xmpp.domain'                               => {
                                                      value => $fqdn
                                                      },
      #Disable TLS
      'xmpp.client.tls.policy'                    => {
                                                      value => 'disabled'
                                                      },
      'xmpp.server.tls.enabled'                   => {
                                                      value => true
                                                      },
      'xmpp.server.dialback.enabled'              => {
                                                      value => true
                                                      },
      'xmpp.server.certificate.accept-selfsigned' => {
                                                      value => false
                                                      },
      #Disable SSL
      'xmpp.socket.ssl.active'                    => {
                                                      value => false
                                                      },
    },
    plugins       => $of_plugins,
  }

  ::openfire::room { 'dev':
    room_name   => 'dev',
    description => 'Development Group',
    require     => Class['::openfire'],
  } ->
  ::openfire::user { 'hubot':
    password => $of_hubot_pass,
  } ->
  ::openfire::group { 'bots': } ->
  ::openfire::usergroup { 'hubot>bots' :
    user  => 'hubot',
    group => 'bots',
  }

}