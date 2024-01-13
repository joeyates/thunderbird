# frozen_string_literal: true

class Thunderbird
  RSpec.describe Profiles, type: :aruba do
    let(:good_profile) { "Profile1" }
    let(:good_path) { "a-profile-path" }
    let(:good_name) { "a-profile-name" }
    let(:install_title) { "Install999" }
    let(:profile) { "profile" }

    before do
      write_thuderbird_profile <<~PROFILE
        [#{good_profile}]
        Name=#{good_name}
        Path=#{good_path}

        [#{install_title}]
        Default=Foo
      PROFILE

      allow(Profile).to receive(:new).with(title: "Profile1", entries: anything) { profile }
    end

    describe ".profile_for_path" do
      let(:path) { good_path }
      let(:result) { subject.profile_for_path(path) }

      it "returns the profile" do
        expect(result).to eq(profile)
      end

      context "when no path matches" do
        let(:path) { "path-that-doesn't-exist" }

        it "returns nil" do
          expect(result).to be_nil
        end
      end
    end

    describe ".profile" do
      let(:name) { good_name }
      let(:result) { subject.profile(name) }

      it "returns the profile" do
        expect(result).to eq(profile)
      end

      context "when no name matches" do
        let(:name) { "name-that-doesn't-exist" }

        it "returns nil" do
          expect(result).to be_nil
        end
      end
    end

    describe ".installs" do
      let(:install) { "install" }
      let(:installs) { [install] }
      let(:result) { subject.installs }

      before do
        allow(Thunderbird::Install).
          to receive(:new).with(title: install_title, entries: anything) { install }
      end

      it "returns all Installs" do
        expect(result).to eq(installs)
      end
    end
  end
end
