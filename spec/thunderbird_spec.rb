# frozen_string_literal: true

RSpec.describe Thunderbird do
  it "has a version number" do
    expect(Thunderbird::VERSION).not_to be nil
  end

  describe ".data_path" do
    [
      ["Linux",   true,  false, false, "$HOME + .thunderbird", File.expand_path("~/.thunderbird")],
      ["macOS",   false, true,  false, "$HOME + Library/Thunderbird", File.expand_path("~/Library/Thunderbird")],
      ["Windows", false, false, true,  "%APPDATA% + Thunderbird", "APPDATA_PATH/Thunderbird"]
    ].each do |os, is_linux, is_macos, is_windows, description, expected|
      context "when on Linux" do
        before do
          allow(OS).to receive(:linux?) { is_linux }
          allow(OS).to receive(:mac?) { is_macos }
          allow(OS).to receive(:windows?) { is_windows }
        end

        around do |example|
          if is_windows
            @previous = ENV["APPDATA"]
            ENV["APPDATA"] = "APPDATA_PATH"
          end
          example.run
          if is_windows
            ENV["APPDATA"] = @previous
          end
        end

        it "is #{description}" do
          expect(subject.data_path).to eq(expected)
        end
      end
    end
  end
end
