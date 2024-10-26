require "spec_helper"
require "custom_form_generator/helpers/yaml_loader"

RSpec.describe CustomFormGenerator::Helpers::YamlLoader do
  let(:dummy_class) { Class.new { extend CustomFormGenerator::Helpers::YamlLoader } }

  describe "#load_yaml" do
    it "loads YAML file correctly" do
      yaml_path = File.join("spec", "fixtures", "form.yml")
      # puts "Loading YAML file: #{subject.load_yaml(yaml_path).inspect}"
      expect(dummy_class.load_yaml(yaml_path)).to be_a(Array)
    end
  end
end
