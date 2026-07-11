#
# Cookbook:: datadog-agent
# Recipe:: repository
#


# Install required packages

package %w(
  curl
  gnupg
  apt-transport-https
) do
  action :install
end

# Create a directory that is used by ubuntu for keys 
#

directory '/usr/share/keyrings' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


# Download the GPG key
#
remote_file '/usr/share/keyrings/datadog-archive-keyring.gpg' do
  source 'https://keys.datadoghq.com/DATADOG_APT_KEY_CURRENT.public'
  mode '0644'
  action :create
end


# Add Template resource to create  /etc/apt/sources.list.d/datadog.list
#

template '/etc/apt/sources.list.d/datadog.list' do
  source 'datadog.list.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# This creates  manually /etc/apt/sources.list.d/datadog.list
#
file '/etc/apt/sources.list.d/datadog.list' do
  content <<~EOF
    deb [signed-by=/usr/share/keyrings/datadog-archive-keyring.gpg] https://apt.datadoghq.com stable 7
  EOF

  owner 'root'
  group 'root'
  mode '0644'
  notifies :update, 'apt_update[update package cache]', :immediately
end

apt_update 'update package cache' do
  action :nothing
end

# Update APT cache 
#
execute 'apt-update' do
  command 'apt-get update'
  action :run
end

