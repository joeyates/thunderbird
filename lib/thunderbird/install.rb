# frozen_string_literal: true

require "thunderbird/profiles"

class Thunderbird
  # Represents an installation of Thunderbird
  class Install
    attr_reader :title
    attr_reader :entries

    # entries are lines from profile.ini
    def initialize(title:, entries:)
      @title = title
      @entries = entries
    end

    def default
      Profiles.new.profile_for_path(entries[:Default])
    end
  end
end
