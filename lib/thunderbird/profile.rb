# frozen_string_literal: true

require "thunderbird"

class Thunderbird
  # A configured user profile
  class Profile
    attr_reader :title
    attr_reader :entries

    # entries are lines from profile.ini
    def initialize(title:, entries:)
      @title = title
      @entries = entries
    end

    def root
      if relative?
        File.join(Thunderbird.new.data_path, entries[:Path])
      else
        entries[:Path]
      end
    end

    def local_folders_path
      File.join(root, "Mail", "Local Folders")
    end

    private

    def relative?
      entries[:IsRelative] == "1"
    end
  end
end
