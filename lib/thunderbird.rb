# frozen_string_literal: true

require "os"

# Require all files so they get counted in coverage
Dir.chdir(__dir__) do
  glob = File.join("**", "*.rb")
  Dir[glob].each { |f| require_relative f }
end

# Root information
class Thunderbird
  VERSION = Version::VERSION

  def data_path
    case
    when OS.linux?
      File.join(Dir.home, ".thunderbird")
    when OS.mac?
      File.join(Dir.home, "Library", "Thunderbird")
    when OS.windows?
      File.join(ENV["APPDATA"].gsub("\\", "/"), "Thunderbird")
    end
  end
end
