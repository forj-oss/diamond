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
  $gitlab_user      = hiera('diamond_project::gitlab::gitlab_user'    ,'git'),
  $gitlab_group     = hiera('diamond_project::gitlab::gitlab_group'   ,'git'),
  $gitlab_home      = hiera('diamond_project::gitlab::gitlab_home'    ,'/home/git'),
  $gitlab_repo      = hiera('diamond_project::gitlab::gitlab_repo'    ,'https://gitlab.com/gitlab-org/gitlab-ce.git'),
  $gitlab_branch    = hiera('diamond_project::gitlab::gitlab_branch'  ,'7-1-stable'),
  $gitlab_db_type   = hiera('diamond_project::gitlab::gitlab_db_type' ,'mysql'),
  $gitlab_db_pass   = hiera('diamond_project::gitlab::gitlab_db_pass' ,'changeme'),
){
  class { '::gitlab':
    gitlab_user    => $gitlab_user,
    gitlab_group   => $gitlab_group,
    gitlab_home    => $gitlab_home,
    gitlab_repo    => $gitlab_repo,
    gitlab_branch  => $gitlab_branch,
    gitlab_db_type => $gitlab_db_type,
    gitlab_db_pass => $gitlab_db_pass,
  }
}
