# == Class: diamond_project::hubot
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
class diamond_project::hubot (
  $chat_bot_user        = 'hubot',
  $chat_bot_password    = 'changeme',
  $chat_fqdn            = $::fqdn,
  $chat_ip              = $::ipaddress,
  $chat_bot_displayname = '[0__0]',
  $bot_listening_port   = '5555',
  $chat_room            = 'dev',
  $chat_room_password   = '123456',
){
  $room = "${chat_room}@conference.${chat_fqdn}"

  class { '::hubot':
    bot_name         => 'xmpp-bot',
    display_name     => $chat_bot_displayname,
    adapter          => 'xmpp',
    #build_deps       => [ 'node-stringprep' ],
    env_export       => {
                        #XMPP specific env variables
                        'HUBOT_XMPP_USERNAME'                => "${chat_bot_user}@${chat_fqdn}",
                        'HUBOT_XMPP_PASSWORD'                => $chat_room_password,
                        'HUBOT_XMPP_ROOMS'                   => $room,
                        'HUBOT_XMPP_HOST'                    => $chat_ip,
                        'PORT'                               => $bot_listening_port,
                        #Gitlab
                        'GITLAB_CHANNEL'                     => $room,
                        'GITLAB_DEBUG'                       => true,
                        #STACKATO
                        'HUBOT_STACKATO_EVENT_NOTIFIER_ROOM' => $room,
                        },
    dependencies     => {
                        'htmlparser'        => '1.7.6',
                        'hubot'             => '>= 2.6.0 < 2.9.0',
                        'hubot-gocd'        => '>= 0.0.4',
                        'hubot-scripts'     => '>= 2.5.0 < 3.0.0',
                        'hubot-xmpp'        => '0.1.0',
                        'node-xmpp'         => '0.3.2',
                        'optparse'          => '1.0.4',
                        'soupselect'        => '0.2.0',
                        'underscore'        => '1.3.3',
                        'underscore.string' => '2.2.0rc',
                        'cron'              => '>= 1.0.1',
                        'redis'             => '0.12.1',
                        'moment'            => '2.8.3',
                        'url'               => '0.10.1',
                        'util'              => '0.10.3',
                        'querystring'       => '0.2.0',
                        },
    scripts          => [
                        'redis-brain.coffee',
                        'shipit.coffee',
                        'reload.coffee',
                        'gitlab.coffee',
                        ],
    external_scripts => [
                        'hubot-gocd'
                        ],
  }
}
