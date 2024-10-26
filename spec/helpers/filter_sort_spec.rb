require "spec_helper"
require "slim"
require "custom_form_generator/helpers/filter_sort"

RSpec.describe CustomFormGenerator::Helpers::FilterSort do
  include CustomFormGenerator::Helpers::FilterSort

  let(:config) do
    {
      "sort" => [
        { "key" => "name", "label" => "Name" },
        { "key" => "created_at", "label" => "Created At" }
      ],
      "filter" => [
        { "key" => "language", "label" => "Language" },
        { "key" => "properties.categories", "label" => "Categories", "type" => "checkbox" },
        { "key" => "published_at", "label" => "Published At", "type" => "radio", "options" => %w[all yes no],
          "default" => "all" }
      ],
      "order_by" => [
        { "key" => "asc", "label" => "Ascending" },
        { "key" => "desc", "label" => "Descending" }
      ]
    }
  end

  let(:data) do
    [
      {
        "language" => "jp",
        "properties" => {
          "categories" => ["/Yusuke/Urameshi"]
        }
      }
    ]
  end

  describe "#generate_updated_config" do
    it "generates an updated config" do
      updated_config = generate_updated_config(config, data)
      expect(updated_config["filter"][0]["options"]).to include(
        "value" => "Jp",
        "label" => "Jp"
      )
      expect(updated_config["filter"][1]["options"]).to include(
        "value" => "Yusuke Urameshi",
        "label" => "Yusuke Urameshi"
      )
    end
  end

  describe "#filter_and_sort_template" do
    it "generates filter and sort template with all components" do
      updated_config = generate_updated_config(config, data)
      template = Slim::Template.new { filter_and_sort_template(updated_config) }.render(
        Object.new, updated_config: updated_config
      )
      expect(template).to include('value="name"')
      expect(template).to include('value="asc"')
      expect(template).to include('type="radio"')
      expect(template).to include('type="checkbox"')
      expect(template).to include('type="submit"')
    end
  end
end
