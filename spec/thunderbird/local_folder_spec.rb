# frozen_string_literal: true

class Thunderbird
  RSpec.describe LocalFolder, type: :aruba do
    subject { described_class.new(profile, path) }

    let(:profile) { "profile" }
    let(:path) { "subdirectory/folder" }
    let(:subdirectory) do
      instance_double(
        Subdirectory,
        set_up: "ciao",
        full_path: full_subdirectory_path
      )
    end
    let(:full_subdirectory_path) { File.expand_path("~/foo.sbd") }
    let(:full_folder_path) { File.join(full_subdirectory_path, "folder") }
    let(:msf_path) { "#{full_folder_path}.msf" }

    before do
      allow(Subdirectory).to receive(:new) { subdirectory }
    end

    describe ".set_up" do
      let!(:result) { subject.set_up }

      it "sets up the subdirectory" do
        expect(subdirectory).to have_received(:set_up)
      end

      it "returns the result of subdirectory.set_up" do
        expect(result).to eq("ciao")
      end

      context "when the path is blank" do
        let(:path) { "" }

        it "does nothing" do
          expect(subdirectory).to_not have_received(:set_up)
        end

        it "returns false" do
          expect(result).to be false
        end
      end

      context "when the folder isn't in a subdirectory" do
        let(:path) { "folder" }

        it "does nothing" do
          expect(subdirectory).to_not have_received(:set_up)
        end

        it "returns true" do
          expect(result).to be true
        end
      end
    end

    describe ".full_path" do
      it "is the subdirectory path plus the folder name" do
        expect(subject.full_path).to eq(full_folder_path)
      end

      context "when the folder isn't in a subdirectory" do
        let(:path) { "folder" }

        it "is the same as the path" do
          expect(subject.full_path).to eq("folder")
        end
      end
    end

    describe ".exists?" do
      context "when the folder exists" do
        before do
          touch(full_folder_path)
        end

        it "is true" do
          expect(subject.exists?).to be true
        end
      end

      context "when the folder doesn't exist" do
        it "is false" do
          expect(subject.exists?).to be false
        end
      end
    end

    describe ".msf_path" do
      it "is the full path plus .msf" do
        expect(subject.msf_path).to eq(msf_path)
      end
    end

    describe ".msf_exists?" do
      context "when the .msf exists" do
        before { touch(msf_path) }

        it "is true" do
          expect(subject.msf_exists?).to be true
        end
      end

      context "when the .msf doesn't exist" do
        it "is false" do
          expect(subject.msf_exists?).to be false
        end
      end
    end
  end
end
