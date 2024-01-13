# frozen_string_literal: true

class Thunderbird
  RSpec.describe Subdirectory, type: :aruba do
    subject { described_class.new(root: local_folders_path, path: subdirectory_path) }

    let(:subdirectory_path) { "subdirectory_path" }
    let(:sbd_path) { "subdirectory_path.sbd" }
    let(:placeholder_path) { "subdirectory_path" }

    let(:profile) { Profile.new(title: "title", entries: entries) }
    let(:entries) { {Path: profile_path, IsRelative: "1"} }
    let(:profile_path) { "profile_path" }
    let(:local_folders_path) do
      File.join(
        Thunderbird.new.data_path,
        profile_path,
        "Mail",
        "Local Folders"
      )
    end
    let(:full_sbd_path) { File.join(local_folders_path, sbd_path) }
    let(:full_placeholder_path) { File.join(local_folders_path, placeholder_path) }

    describe ".set_up" do
      let(:result) { subject.set_up }

      before do
        allow(Kernel).to receive(:puts)
      end

      it "creates the subdirectory" do
        result

        expect(exist?(full_sbd_path)).to be true
      end

      it "creates the placeholder" do
        full_placeholder_path = File.join(local_folders_path, placeholder_path)

        result

        expect(file?(full_placeholder_path)).to be true
      end

      it "returns true" do
        expect(result).to be true
      end

      context "when the path is blank" do
        let(:subdirectory_path) { "" }

        it "fails" do
          expect do
            result
          end.to raise_error(RuntimeError, /without a path/)
        end
      end

      context "when this is a sub-sub-directory" do
        let(:subdirectory_path) { "parent/child" }
        let(:sbd_path) { "parent.sbd/child.sbd" }
        let(:placeholder_path) { "parent.sbd/child" }
        let(:parent) { instance_double(Subdirectory, set_up: parent_result) }
        let(:parent_result) { true }

        before do
          allow(described_class).to receive(:new).and_call_original
          allow(described_class).to receive(:new).with(root: local_folders_path, path: "parent") { parent }
        end

        it "sets up its parent" do
          result

          expect(parent).to have_received(:set_up)
        end

        context "when the parent cannot be set up" do
          let(:parent_result) { false }

          it "returns false" do
            expect(result).to be false
          end
        end
      end

      context "when the subdirectory exists" do
        before do
          create_directory(full_sbd_path)
        end

        context "when the placeholder is missing" do
          it "returns false" do
            expect(result).to be false
          end
        end
      end

      context "when the subdirectory path is not a directory" do
        before do
          touch(full_sbd_path)
          touch(full_placeholder_path)
        end

        it "returns false" do
          expect(result).to be false
        end
      end

      context "when the placeholder exists, but is not a regular file" do
        before { create_directory(full_placeholder_path) }

        it "returns false" do
          expect(result).to be false
        end
      end
    end

    describe ".full_path" do
      it "returns the full path" do
        expect(subject.full_path).to eq(full_sbd_path)
      end
    end
  end
end
