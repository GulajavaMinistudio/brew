# typed: false
# frozen_string_literal: true

require "livecheck/livecheck_version"

describe Homebrew::Livecheck::LivecheckVersion do
  let(:formula) { instance_double(Formula) }
  let(:cask) { instance_double(Cask::Cask) }

  before do
    # Case statements use #=== for case equality purposes
    allow(Formula).to receive(:===).and_call_original
    allow(Formula).to receive(:===).with(formula).and_return(true)
    allow(Cask::Cask).to receive(:===).and_call_original
    allow(Cask::Cask).to receive(:===).with(cask).and_return(true)
  end

  specify "::create" do
    expect(described_class.create(formula, Version.new("1.1.6")).versions).to eq ["1.1.6"]
    expect(described_class.create(formula, Version.new("2.19.0,1.8.0")).versions).to eq ["2.19.0,1.8.0"]
    expect(described_class.create(formula, Version.new("1.0,100:1426778671")).versions).to eq ["1.0,100:1426778671"]
    expect(described_class.create(formula, Version.new("0.17.0,20210111183933,226")).versions)
      .to eq ["0.17.0,20210111183933,226"]

    expect(described_class.create(cask, Version.new("1.1.6")).versions).to eq ["1.1.6"]
    expect(described_class.create(cask, Version.new("2.19.0,1.8.0")).versions).to eq ["2.19.0", "1.8.0"]
    expect(described_class.create(cask, Version.new("1.0,100:1426778671")).versions)
      .to eq ["1.0", "100", "1426778671"]
    expect(described_class.create(cask, Version.new("0.17.0,20210111183933,226")).versions)
      .to eq ["0.17.0", "20210111183933", "226"]
  end
end
