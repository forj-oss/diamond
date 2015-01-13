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
  $vhost_name       = hiera('diamond_project::gitlab::vhost_name'       ,$::fqdn),
  $gitlab_user      = hiera('diamond_project::gitlab::gitlab_user'      ,'git'),
  $gitlab_user_home = hiera('diamond_project::gitlab::gitlab_user_home' ,'/home/git'),
  $gitlab_group     = hiera('diamond_project::gitlab::gitlab_group'     ,'git'),
  $gitlab_ruby_ver  = hiera('diamond_project::gitlab::gitlab_ruby_ver'  ,'2.1.2'),
  $gitlab_repo      = hiera('diamond_project::gitlab::gitlab_repo'      ,'https://gitlab.com/gitlab-org/gitlab-ce.git'),
  $gitlab_branch    = hiera('diamond_project::gitlab::gitlab_branch'    ,'7-3-stable'),
  $gitlab_shell_ver = hiera('diamond_project::gitlab::gitlab_shell_ver' ,'2.0.1'),
  $gitlab_db_type   = hiera('diamond_project::gitlab::gitlab_db_type'   ,'mysql'),
  $gitlab_db_user   = hiera('diamond_project::gitlab::gitlab_db_user'   ,'git'),
  $gitlab_db_pass   = hiera('diamond_project::gitlab::gitlab_db_pass'   ,'changeme'),
  $mail_address     = hiera('diamond_project::gitlab::mail_address'     ,''),
  $mail_port        = hiera('diamond_project::gitlab::mail_port'        ,'22'),
  $mail_user        = hiera('diamond_project::gitlab::mail_user'        ,''),
  $mail_password    = hiera('diamond_project::gitlab::mail_password'    ,''),
  $mail_domain      = hiera('diamond_project::gitlab::mail_domain'      ,$::fqdn),
  $users            = hiera('diamond_project::gitlab::users'            ,undef),
  $projects         = hiera('diamond_project::gitlab::projects'         ,undef),
  $system_hooks     = hiera('diamond_project::gitlab::system_hooks'     ,undef),
  $groups           = hiera('diamond_project::gitlab::groups'           ,undef),
){
  class { '::gitlab':
    vhost_name       => $vhost_name,
    gitlab_user      => $gitlab_user,
    gitlab_user_home => $gitlab_user_home,
    gitlab_group     => $gitlab_group,
    gitlab_ruby_ver  => $gitlab_ruby_ver,
    gitlab_repo      => $gitlab_repo,
    gitlab_branch    => $gitlab_branch,
    gitlab_shell_ver => $gitlab_shell_ver,
    gitlab_db_type   => $gitlab_db_type,
    gitlab_db_user   => $gitlab_db_user,
    gitlab_db_pass   => $gitlab_db_pass,
    mail_address     => $mail_address,
    mail_port        => $mail_port,
    mail_user        => $mail_user,
    mail_password    => $mail_password,
    mail_domain      => $mail_domain,
  } ->
  ::gitlab::configure::user { "jenkins@${::fqdn}":
    username    => 'jenkins',
    real_name   => 'Jenkins CI',
    avatar_file => 'puppet:///modules/diamond_project/gitlab/jenkins.png',
  }

  if $users {
    validate_hash($users)
    create_resources('gitlab::configure::user', $users)
  }
  if $projects {
    validate_hash($projects)
    create_resources('gitlab::configure::project', $projects)
  }
  if $system_hooks {
    validate_hash($system_hooks)
    create_resources('gitlab::configure::system_hook', $system_hooks)
  }
  if $groups {
    validate_hash($groups)
    create_resources('gitlab::configure::group', $groups)
  }

  #jenkins::job { 'modus_merge_request':
  #  config => 'true',
  #}
  #jenkins::job { 'modus_master':
  #  config => 'false',
  #  #config => template("${templates}/test-build-job.xml.erb"),
  #} ->
  #jenkins::job { 'modus_push':
  #  config => 'true',
  #  #config => template("${templates}/test-build-job.xml.erb"),
  #}

}
