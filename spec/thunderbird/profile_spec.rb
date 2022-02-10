# frozen_string_literal: true

class Thunderbird
  RSpec.describe Profile do
    subject { described_class.new("title", entries) }

    let(:entries) { {Path: path, IsRelative: is_relative} }
    let(:path) { "foo" }
    let(:is_relative) { "1" }

    describe ".root" do
      context "when the path is relative" do
        it "is prefixed with the 'data_path'" do
          expect(subject.root).to eq(
            File.join(Thunderbird.new.data_path, path)
          )
        end
      end

      context "when the path is absolute" do
        let(:is_relative) { "0" }

        it "is the path" do
          expect(subject.root).to eq("foo")
        end
      end
    end

    describe ".local_folders_path" do
      let(:is_relative) { "0" }

      it "is the root + 'Mail/Local Folders'" do
        expect(subject.local_folders_path).to eq(
          "foo/Mail/Local Folders"
        )
      end
    end
  end
end
