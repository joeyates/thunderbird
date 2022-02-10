require "aruba/rspec"

require "thunderbird"

module ThunderbirdProfileHelpers
  def write_thuderbird_profile(content)
    path = File.join(Thunderbird.new.data_path, "profiles.ini")
    FileUtils.mkdir_p File.dirname(path)
    File.write(path, content)
  end
end

Aruba.configure do |config|
  config.home_directory = File.expand_path("./tmp/home")
  config.allow_absolute_paths = true
end

RSpec.configure do |config|
  config.include ThunderbirdProfileHelpers, type: :aruba

  config.before(:suite) do
    FileUtils.rm_rf "./tmp/home"
  end

  config.after do
    FileUtils.rm_rf "./tmp/home"
  end
end
