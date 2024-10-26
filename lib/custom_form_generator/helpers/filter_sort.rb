# frozen_string_literal: true

require "cgi"
require "slim"

module CustomFormGenerator
  module Helpers
    # FilterSort module handles configuration updates and template generation for filtering and sorting
    module FilterSort
      def generate_updated_config(config, data)
        validate_inputs(config, data)
        parsed_data = parse_input_data(config, data)
        update_filter_options(parsed_data)
      end

      def filter_and_sort_template(_updated_config)
        <<-SLIM
          div
            button onclick='showFilterPanel()' Filter
            select name='sort'
              - updated_config['sort'].each do |sort_option|
                option value=sort_option['key'] = sort_option['label']
            select name='order_by'
              - updated_config['order_by'].each do |order_option|
                option value=order_option['key'] = order_option['label']
            div id='filterPanel' style='display:none;'
              - updated_config['filter'].each do |filter_option|
                label = filter_option['label']
                - if filter_option['type'] == 'radio'
                  fieldset
                    legend= filter_option['label']
                    - filter_option['options'].each do |option|
                      input type='radio' name=filter_option['key'] value=option['value']
                      label= option['label']
                    - if filter_option['default']
                      input type='radio' name=filter_option['key'] value=filter_option['default'] checked
                - else
                  - filter_option['options'].each do |option|
                    input type='checkbox' name=filter_option['key'] value=option['value']
                    label= option['label']
            button type='submit' Apply
        SLIM
      end

      private

      def validate_inputs(config, data)
        raise CustomFormGenerator::Error, "Config is not a hash: #{config.class}" unless config.is_a?(Hash)
        raise CustomFormGenerator::Error, "Data is not an array: #{data.class}" unless data.is_a?(Array)
      end

      def parse_input_data(config, data)
        {
          config: config.is_a?(String) ? load_json(config) : config,
          data: data.is_a?(String) ? load_json(data) : data
        }
      end

      def update_filter_options(parsed_data)
        config = parsed_data[:config]
        config["filter"].each do |filter|
          next if filter["options"]&.any?

          unique_values = extract_unique_values(parsed_data[:data], filter["key"])
          update_filter_settings(filter, unique_values)
        end
        config
      end

      def extract_unique_values(data, key)
        data.map { |entry| extract_value(entry, key) }
            .flatten
            .uniq
            .compact
      end

      def extract_value(entry, key)
        value = entry[key] || entry.dig(*key.split("."))
        value.is_a?(Array) ? value : [value]
      end

      def update_filter_settings(filter, unique_values)
        filter["default"] ||= unique_values.first if filter["type"] == "radio"
        filter["options"] ||= generate_options(unique_values)
      end

      def generate_options(values)
        values.map do |value|
          formatted_value = format_name(value)
          { "value" => formatted_value, "label" => formatted_value }
        end
      end

      def format_name(name)
        name.gsub("/", " ").strip.split.map(&:capitalize).join(" ")
      end
    end
  end
end
