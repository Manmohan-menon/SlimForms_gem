# spec/generator_spec.rb
require "spec_helper"
require "custom_form_generator"

RSpec.describe CustomFormGenerator::Generator do
  let(:form_yaml) { File.join("spec", "fixtures", "form.yml") }
  let(:data_json) { File.join("spec", "fixtures", "data.json") }
  let(:config_json) { File.join("spec", "fixtures", "config.json") }
  let(:table_yaml) { File.join("spec", "fixtures", "table.yml") }

  subject { described_class.new(form_yaml, data_json, config_json, table_yaml, debug: true) }

  before do
    CustomFormGenerator::Generator.send(:public, :generate_form)
    CustomFormGenerator::Generator.send(:public, :generate_form_with_data)
    CustomFormGenerator::Generator.send(:public, :generate_filter_and_sort)
    CustomFormGenerator::Generator.send(:public, :debug_output)
    CustomFormGenerator::Generator.send(:public, :generate_updated_config)
  end

  after do
    CustomFormGenerator::Generator.send(:private, :generate_form)
    CustomFormGenerator::Generator.send(:private, :generate_form_with_data)
    CustomFormGenerator::Generator.send(:private, :generate_filter_and_sort)
    CustomFormGenerator::Generator.send(:private, :debug_output)
    CustomFormGenerator::Generator.send(:private, :generate_updated_config)
  end

  describe "#generate_form" do
    it "generates form correctly" do
      expect(subject.generate_form).to include("<form")
    end
  end

  describe "#generate_form_with_data" do
    let(:item) { { "properties" => { "name" => "Test Name" } } }

    it "generates form with existing data correctly" do
      form_html = subject.generate_form_with_data(item)
      expect(form_html).to include("Test Name")
    end
  end

  describe "#generate_filter_and_sort" do
    it "generates filter and sort correctly" do
      filter_html = subject.generate_filter_and_sort
      expect(filter_html).to include("Filter")
    end
  end
end
