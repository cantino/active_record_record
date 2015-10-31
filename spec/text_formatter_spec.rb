require 'spec_helper'
require_relative '../lib/active_record_record/text_formatter'
require_relative 'support/example_data'

describe TextFormatter do
  include ExampleData
  let(:ar_counts) { ExampleData::AR_COUNT[:ar_counts][:default] }
  let(:expected_output) { ExampleData::ExpextedTextFormat }

  context "#format" do
    let(:formatted_output) do
      formatter = described_class.new
      formatter.format(ar_counts)
      formatter.lines
    end

    it "will format data into nice rows below the line that initated them" do
      expect(formatted_output).to eq(expected_output)
    end
  end

  context ".format" do
    it "will build a formatter and join the expected results into one string" do
      printed_something, text = described_class.format(ar_counts)
      expect(printed_something).to be_truthy
      expect(text).to eq(expected_output.join)
    end
  end
end
