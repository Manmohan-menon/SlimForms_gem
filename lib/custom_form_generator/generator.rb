# frozen_string_literal: true

require_relative "helpers/yaml_loader"
require_relative "helpers/json_loader"
require_relative "helpers/template_render"
require_relative "helpers/field_renderers"
require_relative "helpers/filter_sort"
require_relative "helpers/table_renderer"

module CustomFormGenerator
  class Generator
    include Helpers::YamlLoader
    include Helpers::JsonLoader
    include Helpers::TemplateRender
    include Helpers::FieldRenderers
    include Helpers::FilterSort
    include Helpers::TableRenderer

    def initialize(form_yaml, data_json, config_json, table_yaml, debug = false)
      @form_yaml = load_yaml(form_yaml)
      @data_json = load_json(data_json)
      @config_json = load_json(config_json)
      @table_yaml = load_yaml(table_yaml)
      @debug = debug
    end

    def generate_form
      Slim::Template.new { form_template }.render(self)
    end

    def generate_filter_and_sort
      updated_config = generate_updated_config(@config_json, @data_json)
      Slim::Template.new { filter_and_sort_template(updated_config) }.render(self)
    end

    def generate_form_with_data(item)
      @data_json = item
      Slim::Template.new { table_template }.render(self)
    end

    private

    def generate_updated_config(config_file, data_file)
      config = load_json(config_file)
      data = load_json(data_file)
    
      config['filter'].each do |filter|
        key = filter['key']
        if filter['options'].nil? || filter['options'].empty?
          unique_values = data.map do |entry|
            value = entry[key]
            value.is_a?(Array) ? value : [value]
          end.flatten.uniq.compact
    
          if filter['type'] == 'radio' && filter['default'].nil?
            filter['default'] = unique_values.first
          end

          filter['options'] = unique_values.map { |value| { "value" => value, "label" => value.capitalize } }
        end
      end
    
      # Returns updated config
      config
    end

  end
end
