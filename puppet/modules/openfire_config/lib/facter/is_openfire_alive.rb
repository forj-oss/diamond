# Copyright 2012 Hewlett-Packard Development Company, L.P
#

Facter.add('is_openfire_alive') do
  confine :kernel => 'Linux'
  setcode do
    ret = Facter::Util::Resolution.exec(Facter.value('forj_script_path') + 'toolstatus.sh openfire')
    ret == '0' ? Facter::Util::Resolution.exec('echo true') : Facter::Util::Resolution.exec('echo false')
  end
end