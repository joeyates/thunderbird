# frozen_string_literal: true

class Thunderbird
  RSpec.describe Install do
    subject { described_class.new(title: "title", entries: entries) }

    let(:entries) { {Default: "path"} }
    let(:profiles) { instance_double(Profiles) }

    before do
      allow(Thunderbird::Profiles).to receive(:new) { profiles }
      allow(profiles).to receive(:profile_for_path).with("path") { "profile" }
    end

    describe ".default" do
      it "returns the default Profile" do
        expect(subject.default).to eq("profile")
      end
    end
  end
end
