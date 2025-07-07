# frozen_string_literal: true

require "mork/parser"

class Thunderbird
  class Mbox
    attr_reader :path

    def initialize(path:)
      @path = path
    end

    def uid_validity
      data.tables[FOLDER_NAMESPACE]["1"]["1"]["UIDValidity"]
    end

    def each(&block)
      messages = data.tables[MESSAGE_NAMESPACE]["1"]
      File.open(path) do |file|
        messages.each do |id, message_info|
          message_size = message_info["offlineMsgSize"]
          length = message_size.to_i(16)
          message = file.read(length)
          block.call(id, message)
        end
      end
    end

    private

    FOLDER_NAMESPACE = "ns:msg:db:row:scope:dbfolderinfo:all"
    MESSAGE_NAMESPACE = "ns:msg:db:row:scope:msgs:all"

    def index_path
      "#{path}.msf"
    end

    def data
      @data ||= begin
        parser = Mork::Parser.new
        content = File.read(index_path)
        parser.data(content)
      end
    end
  end
end
