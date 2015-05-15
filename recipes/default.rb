me = node['current_user']
home = ::File.join(::Dir.home(me))

unless ::File.exist?("#{home}/Google\ Drive/.placeholder.txt")
  Chef::Log.info "\n\n\n\n\t\tPlease execute the Google Drive sync app and rerun kitchenplan.\n\n\n\n"
  return
end

Chef::Log.info "\n\n\n\Google Drive appears to be enabled.\n\n\n"

directory ::File.join(home, "Applications") do
  mode "0700"
  owner me
  group me
end

directory ".keepassx" do
  path ::File.join(home, ".keepassx")
  mode "0700"
  owner me
  group me
end

%w(
config.ini
personal-config.ini
work-config.ini
).each do |config|
  template config do
    path ::File.join(home, ".keepassx", config)
    source "#{config}.erb"
    mode "0644"
    owner me
    group me
  end
end

%w(
KeePassX.app
mykeepassess.app
).each do |app|
  link app do
    target_file ::File.join(home, "Applications", app)
    to ::File.join(home, "Google\ Drive", "keepassx", app)
    owner me
  end
end

file ::File.join(home, "Google\ Drive", "keepassx", "KeePassX.app", "Contents", "MacOS", "KeePassX") do
  action :touch
  mode "0755"
  owner me
  group me
end

%w(
personal.keyfile
work.keyfile
).each do |key|
  link "secret key files: #{key}" do
    target_file ::File.join(home, key)
    to ::File.join(home, "Google\ Drive", "keepassx", key)
    owner me
  end
end

file "mykeepasses.sh" do
  action :touch
  path ::File.join(home, "Google\ Drive", "keepassx", "mykeepasses.sh")
  mode "0755"
  owner me
  group me
end
