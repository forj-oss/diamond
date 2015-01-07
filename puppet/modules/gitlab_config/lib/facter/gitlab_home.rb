# == gitlab_config::gitlab_home
# Copyright 2013 Hewlett-Packard Development Company, L.P.
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
#

Facter.add("gitlab_home") do
  confine :kernel => "Linux"
  setcode do
    if File.exist? "/etc/default/gitlab"
      #the string to look for and the path should change depending on the system to discover
      user = open('/etc/default/gitlab').grep(/app_user=/)
      starting = user[0].index('=') + 2
      ending = user[0][0]
      user = user[0][starting..ending]
      user.gsub! "\n", ""
      home = open('/etc/default/gitlab').grep(/app_root=/)
      starting = home[0].index('=') + 2
      ending = home[0][0]
      home = home[0][starting..ending]
      home.gsub! "\n", ""
      home.gsub! "$app_user", user
      Facter::Util::Resolution.exec("echo #{home}")
    else
      Facter::Util::Resolution.exec("echo")  # gitlab doesn't exist here
    end
  end
end
