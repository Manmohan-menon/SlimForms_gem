# frozen_string_literal: true

require "cgi"

module CustomFormGenerator
  # Helpers module provides form generation and rendering functionality
  # Contains core modules for field rendering, validation, and HTML generation
  module Helpers
    include FormElementRenderer

    # FieldRenderers module handles HTML form field generation with various input types
    # and proper escaping for security
    module FieldRenderers
      def render_field(field)
        validate_field(field)
        field_attributes = extract_field_attributes(field)
        render_field_by_type(field, field_attributes)
      rescue StandardError => e
        raise CustomFormGenerator::Error, "Failed to render field '#{field["key"]}': #{e.message}"
      end

      private

      def validate_field(field)
        raise CustomFormGenerator::Error, "Invalid field structure" unless field.is_a?(Hash)
      end

      def extract_field_attributes(field)
        {
          label: CGI.escapeHTML(field["label"]),
          id: CGI.escapeHTML(field["id"]),
          key: CGI.escapeHTML(field["key"]),
          css_class: CGI.escapeHTML(field["class"]),
          value: fetch_nested_value(field["key"]).to_s,
          type: field["type"]
        }
      end

      def render_field_by_type(field, attrs)
        case attrs[:type]
        when "textfield" then render_textfield(attrs)
        when "dropdown" then render_dropdown(field, attrs)
        when "datetime-local" then render_datetime(field, attrs)
        when "radio" then render_radio(field, attrs)
        when "textbox" then render_textbox(attrs)
        else ""
        end
      end

      def fetch_dropdown_options(field, selected_value)
        options = fetch_nested_value(field["key"])
        return "" unless options.is_a?(Array)

        options.map { |opt| generate_option(opt, opt == selected_value ? "selected" : "") }.join("\n")
      rescue StandardError => e
        raise CustomFormGenerator::Error, "Failed to generate dropdown options: #{e.message}"
      end

      def fetch_radio_options(field, selected_value)
        return "" unless field.is_a?(Hash) && field.key?("options")

        generate_radio_options(field, selected_value)
      rescue StandardError => e
        raise CustomFormGenerator::Error, "Failed to generate radio options: #{e.message}"
      end

      def generate_radio_options(field, selected_value)
        field["options"].map do |opt|
          generate_radio_option(opt, selected_value)
        end.join("<br>")
      end

      def generate_radio_option(opt, selected_value)
        opt_value = CGI.escapeHTML(opt["value"])
        opt_label = CGI.escapeHTML(opt["label"])
        checked = opt["value"] == selected_value ? "checked" : ""
        <<~HTML
          <input type='radio' id='#{id}_#{opt_value}' class='#{css_class}'#{" "}
                 name='#{key}' value='#{opt_value}' #{checked}>
          <label for='#{id}_#{opt_value}'>#{opt_label}</label>
        HTML
      end

      def fetch_nested_value(key)
        keys = key.split(".")
        value = keys.reduce(@data_json) do |data, k|
          return "" unless data.is_a?(Hash) && data.key?(k)

          data[k]
        end
        puts "DEBUG: key = #{key}, value = #{value.inspect}" if @debug
        value.is_a?(Array) ? value : value || ""
      end

      def generate_option(option, selected)
        "<option value='#{CGI.escapeHTML(option)}' #{selected}>#{CGI.escapeHTML(option)}</option>"
      end
    end
  end
end
