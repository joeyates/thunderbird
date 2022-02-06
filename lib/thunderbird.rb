# frozen_string_literal: true

require "os"
require_relative "thunderbird/version"

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
