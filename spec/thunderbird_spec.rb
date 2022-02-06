# frozen_string_literal: true

RSpec.describe Thunderbird do
  it "has a version number" do
    expect(Thunderbird::VERSION).not_to be nil
  end
end
