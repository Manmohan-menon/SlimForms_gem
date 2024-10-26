require "spec_helper"
require "custom_form_generator/helpers/json_loader"

RSpec.describe CustomFormGenerator::Helpers::JsonLoader do
  let(:dummy_class) { Class.new { extend CustomFormGenerator::Helpers::JsonLoader } }

  describe "#load_json" do
    context "when the JSON file is valid" do
      it "loads JSON file correctly" do
        json_path = File.join("spec", "fixtures", "data.json")
        json_data = dummy_class.load_json(json_path)

        expect(json_data).to be_a(Array)
        expect(json_data.first).to be_a(Hash)
      end
    end
  end
end
