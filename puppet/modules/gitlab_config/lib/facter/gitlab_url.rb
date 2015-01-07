# == gitlab_config::gitlab_url
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

require 'yaml'

Facter.add("gitlab_url") do
  confine :kernel => "Linux"
  setcode do

    def recurse(obj, pattern, current_path = [], &block)
      if obj.is_a?(String)
        path = current_path.join('.')
        if obj =~ pattern || path =~ pattern
          yield [path, obj]
        end
      elsif obj.is_a?(Hash)
        obj.each do |k, v|
          recurse(v, pattern, current_path + [k], &block)
        end
      end
    end

    gitlab_config = Facter.value('gitlab_config')
    if File.exist? gitlab_config
      hash = YAML.load_file(gitlab_config)
      recurse(hash, 'production.gitlab.host') do |path, value|
        #Validate property
        #match = "#{path}:\t#{value}"
        #puts match
        gitlab_url = value
      end
      Facter::Util::Resolution.exec("echo http://#{gitlab_url}")
    else
      Facter::Util::Resolution.exec("echo")  # gitlab doesn't exist here
    end

  end
end
