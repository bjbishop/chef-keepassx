unless ::File.exist?("#{::Dir.home(node['current_user'])}/Google\ Drive/.placeholder.txt")
  Chef::Log.info "\n\n\n\n\t\tYou can now run Dropbox and Google Drive and rerun kitchenplan.\n\n\n\n"
  return
end

Chef::Log.info "\n\n\n\Google Drive appears to be enabled.\n\n\n"

directory "Applications" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), "Applications")
  owner node['current_user']
  group node['current_user']
  mode "0700"
  recursive false
end

directory ".keepassx" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".keepassx")
  owner node['current_user']
  group node['current_user']
  mode "0700"
  recursive false
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

link "keepass app" do
  action :create
  target_file ::File.join(::Dir.home(node['current_user']), "Applications", "KeePassX.app")
  to ::File.join(::Dir.home(node['current_user']), "Google Drive", "keepassx", "KeePassX.app")
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
