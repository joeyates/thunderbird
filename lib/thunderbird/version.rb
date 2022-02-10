# frozen_string_literal: true

class Thunderbird
  module Version
    MAJOR    = 0
    MINOR    = 2
    REVISION = 1
    PRE      = nil
    VERSION  = [MAJOR, MINOR, REVISION, PRE].compact.map(&:to_s).join(".")
  end
end
