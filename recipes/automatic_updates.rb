#
# Cookbook Name:: automatic_updates
# Recipe:: automatic_updates
#
# Copyright 2011 Junta de Andalucía
#
# Author::
#  * David Amian Valle <damian@emergya.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

upstart_apt = '/etc/init/automatic-updates.conf'
if node["automatic_updates"]["on_login"] == "true" or node["automatic_updates"]["on_boot"] == "true"
  start_event = ""
  if node["automatic_updates"]["on_login"] == "true"
    if node["automatic_updates"]["on_boot"] == "true"
      start_event = "(runlevel [2] or desktop-session-start)"
    else
      start_event = "desktop-session-start"
    end
  else
    start_event = "runlevel [2]"
  end
  template upstart_apt do
    owner "root"
    group "root"
    mode "0644"
    variables :start_event => start_event
    source "automatic-updates.conf.erb"
  end

else
  if FileTest.exist? upstart_apt
    File.delete upstart_apt
  end

end


if node["automatic_updates"]["on_monday"] != "No" or node["automatic_updates"]["on_tuesday"] != "No" or
node["automatic_updates"]["on_wednesday"] != "No" or node["automatic_updates"]["on_thursday"] != "No" or
node["automatic_updates"]["on_friday"] != "No"
  package 'cron-apt' do
    action :nothing
  end.run_action(:install)
  
  cron_apt_config = "/etc/cron-apt/config"
  cookbook_file cron_apt_config do
    source "apt.config"
    owner "root"
    group "root"
    mode "0644"
  end
  cron_apt_action_update = "/etc/cron-apt/action.d/0-update"
  cookbook_file cron_apt_action_update do
    source "apt_action.update"
    owner "root"
    group "root"
    mode "0644"
  end

  cron_apt_action_upgrade = "/etc/cron-apt/action.d/3-download"
  cookbook_file cron_apt_action_upgrade do
    source "apt_action.upgrade"
    owner "root"
    group "root"
    mode "0644"
  end
  
  cron_values = ""
  if node["automatic_updates"]["on_monday"] != "No"
    hour, min = node["automatic_updates"]["on_monday"].split(":")
    cron_values = cron_values + "\n" + "#{min} #{hour}  * * 1   root    test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt /etc/cron-apt/config"
  end

  if node["automatic_updates"]["on_tuesday"] != "No"
    hour, min = node["automatic_updates"]["on_tuesday"].split(":")
    cron_values = cron_values + "\n" + "#{min} #{hour}  * * 2   root    test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt /etc/cron-apt/config"
  end

  if node["automatic_updates"]["on_wednesday"] != "No"
    hour, min = node["automatic_updates"]["on_wednesday"].split(":")
    cron_values = cron_values + "\n" + "#{min} #{hour}  * * 3   root    test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt /etc/cron-apt/config"
  end

  if node["automatic_updates"]["on_thursday"] != "No"
    hour, min = node["automatic_updates"]["on_thursday"].split(":")
    cron_values = cron_values + "\n" + "#{min} #{hour}  * * 4   root    test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt /etc/cron-apt/config"
  end

  if node["automatic_updates"]["on_friday"] != "No"
    hour, min = node["automatic_updates"]["on_friday"].split(":")
    cron_values = cron_values + "\n" + "#{min} #{hour}  * * 5   root    test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt /etc/cron-apt/config"
  end
  cron_apt = "/etc/cron.d/cron-apt"
  template cron_apt do
    owner "root"
    group "root"
    mode "0644"
    variables :cron_values => cron_values
    source "cron-apt.erb"
  end


else
  package 'cron-apt' do
    action :nothing
  end.run_action(:remove)

end
