#
# Cookbook:: datadog-agent
# Recipe:: repository
#
# Configures the Datadog APT repository.
#

package %w(
  curl
  gnupg
) do
  action :install
end

directory '/usr/share/keyrings' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/datadog.key" do
  # remote_file '/tmp/datadog.key' do   \\ cookstyle doesn't like hardcoding of the path
  source 'https://keys.datadoghq.com/DATADOG_APT_KEY_CURRENT.public'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'dearmor datadog gpg key' do
  command <<~EOH
    gpg --batch --yes \
      --dearmor \
      --output /usr/share/keyrings/datadog-archive-keyring.gpg \
      #{Chef::Config[:file_cache_path]}/datadog.key
  EOH

  creates '/usr/share/keyrings/datadog-archive-keyring.gpg'
end

file '/usr/share/keyrings/datadog-archive-keyring.gpg' do
  owner 'root'
  group 'root'
  mode '0644'
end

apt_update 'update package cache' do
  action :nothing
end

template '/etc/apt/sources.list.d/datadog.list' do
  source 'datadog.list.erb'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :update, 'apt_update[update package cache]', :immediately
end
