me = node['current_user']

unless ::File.exist?("#{::Dir.home(me)}/Google\ Drive/.placeholder.txt")
  Chef::Log.info "\n\n\n\n\t\tPlease execute the Google Drive sync app and rerun kitchenplan.\n\n\n\n"
  return
end

Chef::Log.info "\n\n\n\Google Drive appears to be enabled.\n\n\n"

directory "Applications" do
  mode "0700"
  owner me
  group me
end

directory ".keepassx" do
  path ::File.join(::Dir.home(me), ".keepassx")
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
    path ::File.join(::Dir.home(me), ".keepassx", config)
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
    target_file ::File.join(::Dir.home(me), "Applications", app)
    to ::File.join(::Dir.home(me), "Google\ Drive", "keepassx", app)
  end
end

file ::File.join(::Dir.home(me), "Google\ Drive", "keepassx", "KeePassX.app", "Contents", "MacOS", "KeePassX") do
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
    target_file ::File.join(::Dir.home(me), key)
    to ::File.join(::Dir.home(me), "Google\ Drive", "keepassx", key)
  end
end

file "mykeepasses.sh" do
  action :touch
  path ::File.join(::Dir.home(me), "Google\ Drive", "keepassx", "mykeepasses.sh")
  mode "0755"
  owner me
  group me
end
