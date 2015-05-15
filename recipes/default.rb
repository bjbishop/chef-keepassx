unless ::File.exist?("#{::Dir.home(node['current_user'])}/Google\ Drive/.placeholder.txt")
  Chef::Log.info "\n\n\n\n\t\tPlease execute the Google Drive sync app and rerun kitchenplan.\n\n\n\n"
  return
end

Chef::Log.info "\n\n\n\Google Drive appears to be enabled.\n\n\n"

default_owner = {  :owner => node['current_user'], :group => node['current_user'] }

directory "Applications" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), "Applications")
  default_owner
  mode "0700"
end

directory ".keepassx" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".keepassx")
  owner node['current_user']
  group node['current_user']
  mode "0700"
end

%w(
config.ini
personal-config.ini
work-config.ini
).each do |config|
  template config do
    action :create
    path ::File.join(::Dir.home(node['current_user']), ".keepassx", config)
    source "#{config}.erb"
    mode "0644"
    owner node['current_user']
    group node['current_user']
  end
end

%w(
KeePassX.app
mykeepassess.app
).each do |app|
  link app do
    action :create
    target_file ::File.join(::Dir.home(node['current_user']), "Applications", app)
    to ::File.join(::Dir.home(node['current_user']), "Google Drive", "keepassx", app)
  end
end

file ::File.join(::Dir.home(node['current_user']), "Google Drive", "keepassx", "KeePassX.app", "Contents", "MacOS", "KeePassX") do
  action :touch
  owner node['current_user']
  group node['current_user']
  mode "0755"
end

%w(
personal.keyfile
work.keyfile
).each do |key|
  link "secret key files: #{key}" do
    action :create
    target_file ::File.join(::Dir.home(node['current_user']), key)
    to ::File.join(::Dir.home(node['current_user']), "Google Drive", "keepassx", key)
  end
end

file "mykeepasses.sh" do
  action :touch
  path ::File.join(::Dir.home(node['current_user']), "Google Drive", "keepassx", "mykeepasses.sh")
  owner node['current_user']
  group node['current_user']
  mode "0755"
end
