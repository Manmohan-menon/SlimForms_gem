require "spec_helper"
require "custom_form_generator/helpers/table_renderer"

RSpec.describe CustomFormGenerator::Helpers::TableRenderer do
  include CustomFormGenerator::Helpers::TableRenderer

  let(:data) do
    [
      { "name" => "Test Name", "sku" => "Test SKU" },
      { "name" => "Another Name", "sku" => "Another SKU" }
    ]
  end

  let(:table_template) do
    <<-SLIM
      table
        tr
          th Name
          th SKU
        - data.each do |row|
          tr
            td= row["name"]
            td= row["sku"]
    SLIM
  end

  describe "#generate_tabular_view" do
    it "generates a tabular view" do
      table_html = generate_tabular_view(data: data, table_template: table_template)
      expect(table_html).to include("Test Name")
      expect(table_html).to include("Another SKU")
    end
  end
end
