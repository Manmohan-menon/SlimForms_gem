# frozen_string_literal: true

require "json"
require "slim"
require "yaml"
require_relative "helpers/yaml_loader"
require_relative "helpers/json_loader"
require_relative "helpers/template_render"
require_relative "helpers/form_element_renderer"
require_relative "helpers/field_renderers"
require_relative "helpers/filter_sort"
require_relative "helpers/table_renderer"

module CustomFormGenerator
  # The Generator class is responsible for orchestrating the loading and rendering
  # of form configurations, data, and templates. It integrates various helper modules
  # to process YAML and JSON files, and to render forms and UI components using Slim templates.
  class Generator
    include Helpers::YamlLoader
    include Helpers::JsonLoader
    include Helpers::TemplateRender
    include Helpers::FieldRenderers
    include Helpers::FilterSort
    include Helpers::TableRenderer
    include Helpers::FormElementRenderer

    def initialize(form_yaml, data_json, config_json, table_yaml, debug: false)
      load_files(form_yaml, data_json, config_json, table_yaml)
      @debug = { debug: debug }
    rescue StandardError => e
      raise CustomFormGenerator::Error, "Failed to load generator files: #{e.message}"
    end

    private

    def load_files(form_yaml, data_json, config_json, table_yaml)
      @form_yaml = load_yaml(form_yaml)
      @data_json = load_json(data_json)
      @config_json = load_json(config_json)
      @table_yaml = load_yaml(table_yaml)
    rescue StandardError => e
      raise CustomFormGenerator::Error, "Failed to load files: #{e.message}"
    end

    def generate_form
      debug_output("Generating form") if @debug
      Slim::Template.new { form_template }.render(self)
    end

    def generate_filter_and_sort
      debug_output("Generating filter and sort") if @debug
      updated_config = generate_updated_config(@config_json, @data_json)
      Slim::Template.new { filter_and_sort_template(updated_config) }.render(self, updated_config: updated_config)
    end

    def generate_form_with_data(item)
      debug_output("Generating form with data") if @debug
      @data_json = item
      Slim::Template.new { form_template }.render(self)
    end

    def debug_output(message)
      puts "[DEBUG] #{message}" if @debug[:debug]
    end
  end
end
