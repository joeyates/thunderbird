# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

require "thunderbird"

Dir.chdir(__dir__) do
  glob = File.join("support", "**", "*.rb")
  Dir[glob].sort.each { |f| require_relative f }
end
