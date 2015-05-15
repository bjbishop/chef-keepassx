unless ::File.exist?("#{::Dir.home(node['current_user'])}/Google\ Drive/.placeholder.txt")
  Chef::Log.info "\n\n\n\n\t\tYou can now run Dropbox and Google Drive and rerun kitchenplan.\n\n\n\n"
  return
end

Chef::Log.info "\n\n\n\Google Drive appears to be enabled.\n\n\n"

directory ".keepassx" do
  action :create
  path ::File.join(::Dir.home(node['current_user']), ".keepassx")
  owner node['current_user']
  group node['current_user']
  mode "0700"
  recursive false
end

template "config.ini" do
  action :create
  source "config.ini.erb"
  mode "0644"
  owner node['current_user']
  group node['current_user']
end

