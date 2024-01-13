# frozen_string_literal: true

RSpec.describe Thunderbird do
  it "has a version number" do
    expect(Thunderbird::VERSION).not_to be_nil
  end

  describe ".data_path" do
    [
      ["Linux",   "$HOME + .thunderbird", File.expand_path("~/.thunderbird")],
      ["macOS",   "$HOME + Library/Thunderbird", File.expand_path("~/Library/Thunderbird")],
      ["Windows", "%APPDATA% + Thunderbird", "APPDATA_PATH/Thunderbird"]
    ].each do |os, description, expected|
      context "when on #{os}" do
        before do
          allow(OS).to receive(:linux?) { os == "Linux" }
          allow(OS).to receive(:mac?) { os == "macOS" }
          allow(OS).to receive(:windows?) { os == "Windows" }
        end

        around do |example|
          if os == "Windows"
            reset = ENV.fetch("APPDATA") if ENV.key?("APPDATA")
            ENV["APPDATA"] = "APPDATA_PATH"
          end

          example.run

          ENV["APPDATA"] = reset if reset
        end

        it "is #{description}" do
          expect(subject.data_path).to eq(expected)
        end
      end
    end
  end
end
