# frozen_string_literal: true

require "mork/parser"

class Thunderbird
  class Mbox
    attr_reader :path

    def initialize(path:)
      @path = path
    end

    def each(&block)
      content = File.read(path)
      data = parser.data(content)
      messages = data.tables[MESSAGE_NAMESPACE]["1"]
      File.open(index_path) do |file|
        messages.each do |id, message_info|
          message_size = message_info["offlineMsgSize"]
          length = message_size.to_i(16)
          message = file.read(length)
          block.call(id, message)
        end
      end
    end

    private

    MESSAGE_NAMESPACE = "ns:msg:db:row:scope:msgs:all"

    def parser
      @parser ||= Mork::Parser.new
    end

    def index_path
      "#{path}.msf"
    end
  end
end
