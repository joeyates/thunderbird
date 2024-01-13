# frozen_string_literal: true

require "thunderbird/subdirectory"

class Thunderbird
  # A local folder is a file containing emails
  # It is not a "live" folder that is sync-able with an online account
  class LocalFolder
    attr_reader :path
    attr_reader :profile

    def initialize(profile:, path:)
      @profile = profile
      @path = path
    end

    def set_up
      return false if path_elements.empty?

      return true if !in_subdirectory?

      subdirectory.set_up
    end

    def full_path
      if in_subdirectory?
        File.join(subdirectory.full_path, folder_name)
      else
        path
      end
    end

    def exists?
      File.exist?(full_path)
    end

    def msf_path
      "#{full_path}.msf"
    end

    def msf_exists?
      File.exist?(msf_path)
    end

    private

    def in_subdirectory?
      path_elements.count > 1
    end

    def subdirectory
      return nil if !in_subdirectory?

      Subdirectory.new(path: subdirectory_path, root: profile.local_folders_path)
    end

    def path_elements
      path.split(File::SEPARATOR)
    end

    def subdirectory_path
      File.join(path_elements[0..-2])
    end

    def folder_name
      path_elements[-1]
    end
  end
end
