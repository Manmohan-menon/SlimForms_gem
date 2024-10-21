# frozen_string_literal: true

require_relative "custom_form_generator/version"
require 'json'
require 'slim'
require 'yaml'
require 'cgi'

module CustomFormGenerator
  class Error < StandardError; end

  class Generator
    def initialize(form_yaml, data_json, config_json, table_yaml)
      @form_yaml = load_yaml(form_yaml)
      @data_json = load_json(data_json)
      @config_json = load_json(config_json)
      @table_yaml = load_yaml(table_yaml)
    end

    def generate_form
      Slim::Template.new { form_template }.render(self)
    end

    def generate_filter_and_sort
      Slim::Template.new { filter_and_sort_template }.render(self)
    end

    # adding tabular view
    def generate_tabular_view(data)
      Slim::Template.new { table_template }.render(self, data: data)
    end

    private

    def load_yaml(file_path)
      YAML.load_file(file_path)
    rescue StandardError => e
      raise Error, "Failed to load YAML file #{file_path}: #{e.message}"
    end

    def load_json(file_path)
      JSON.parse(File.read(file_path))
    rescue StandardError => e
      raise Error, "Failed to load JSON file #{file_path}: #{e.message}"
    end

    def form_template
      <<-SLIM
        form
          - @form_yaml.each do |field|
            - next if field['key'] == '_id'
            == render_field(field)
            br
      SLIM
    end

    def render_field(field)
      label = CGI.escapeHTML(field['label'])
      id = CGI.escapeHTML(field['id'])
      key = CGI.escapeHTML(field['key'])
      css_class = CGI.escapeHTML(field['class'])
      value = CGI.escapeHTML(fetch_nested_value(field['key']).to_s)

      case field['type']
      when 'textfield'
        "<label for='#{id}'>#{label}</label>
        <input type='text' id='#{id}' class='#{css_class}' name='#{key}' value='#{value}' placeholder='Enter your #{key}'/>"
      when 'dropdown'
        options = value.is_a?(Array) ? value.map { |opt| "<option value='#{CGI.escapeHTML(opt)}'>#{CGI.escapeHTML(opt)}</option>" }.join("\n") : ''
        "<label for='#{id}'>#{label}</label>
        <select id='#{id}' class='#{css_class}' name='#{key}'>\n#{options}\n</select>"
      when 'datetime-local'
        disabled_attr = field['disabled'] ? 'disabled' : ''
        "<label for='#{id}'>#{label}</label>
        <input type='datetime-local' id='#{id}' class='#{css_class}' name='#{key}' value='#{value}' #{disabled_attr} />"
      when 'radio'
        options = field['options'].map { |opt| 
          opt_value = CGI.escapeHTML(opt['value'])
          opt_label = CGI.escapeHTML(opt['label'])
          "<input type='radio' id='#{id}_#{opt_value}' class='#{css_class}' name='#{key}' value='#{opt_value}'><label for='#{id}_#{opt_value}'>#{opt_label}</label>" 
        }.join("<br>")
        "<fieldset>
          <legend>#{label}</legend>
          #{options}
        </fieldset>"
      when 'textbox'
        "<label for='#{id}'>#{label}</label>
        <textarea id='#{id}' class='#{css_class}' name='#{key}' placeholder='Enter your #{key}'>#{value}</textarea>"
      else
        ''
      end
    end

    def fetch_nested_value(key)
      keys = key.split('.')
      value = keys.reduce(@data_json) do |data, k|
        return '' unless data.is_a?(Hash) && data.key?(k)
        data[k]
      end
      puts "DEBUG: key = #{key}, value = #{value.inspect}"
      value.is_a?(Array) ? value : value || ''
    end

    def filter_and_sort_template
      <<-SLIM
        div
          button onclick='showFilterPanel()' Filter
          select name='sort'
            - @config_json['sort'].each do |sort_option|
              option value=sort_option['key'] = sort_option['label']
          select name='order_by'
            - @config_json['order_by'].each do |order_option|
              option value=order_option['key'] = order_option['label']
          div id='filterPanel' style='display:none;'
            - @config_json['filter'].each do |filter_option|
              label = filter_option['label']
              - if filter_option['type'] == 'radio'
                fieldset
                  legend= filter_option['label']
                  - filter_option['options'].each do |option|
                    input type='radio' name=filter_option['key'] value=option
                    label= option.capitalize
                  - if filter_option['default']
                    input type='radio' name=filter_option['key'] value=filter_option['default'] checked
              - else
                input type='checkbox' name=filter_option['key']
          button type='submit' Apply
      SLIM
    end

    def table_template
      <<-SLIM
        table
          tr
            - @table_yaml.each do |field|
              th id=CGI.escapeHTML(field["id"]) class=CGI.escapeHTML(field["class"]) = field['label']
            th Activities
          - data.each do |entry|
            tr
              - @table_yaml.each do |field|
                td id=CGI.escapeHTML(field["id"]) class=CGI.escapeHTML(field["class"])
                  - value = entry.dig(*field['key'].split('.'))
                  - if field['key'] == 'properties.published_at' && value.nil?
                    | false
                  - elsif field['key'] == 'properties.image_url' && value.nil?
                    img src='/path/to/default_image.jpg' alt='Default Thumbnail'
                  - else
                    = value
              td
                button class='edit-button' data-id=entry['_id']['$oid'] Edit
                button class='delete-button' data-id=entry['_id']['$oid'] Delete
      SLIM
    end    
  end
end