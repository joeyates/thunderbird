# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

require "thunderbird"

$LOAD_PATH << __dir__
support_files = Dir.chdir(__dir__) do
  glob = File.join("support", "**", "*.rb")
  Dir[glob].sort
end
support_files.each { |f| require f }
