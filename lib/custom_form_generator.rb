# frozen_string_literal: true

require_relative "custom_form_generator/version"
require 'json'
require 'slim'
require 'yaml'

module CustomFormGenerator
  class Error < StandardError; end
  class Generator
    def initialize(form_yaml, data_json, config_json, table_yaml)
      @form_yaml = YAML.load_file(form_yaml)
      @data_json = JSON.parse(File.read(data_json))
      @config_json = JSON.parse(File.read(config_json))
      @table_yaml = YAML.load_file(table_yaml)
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
      case field['type']
      when 'textfield'
        "<label for='#{field['id']}'>#{field['label']}</label>
         <input type='text' id='#{field['id']}' class='#{field['class']}' name='#{field['key']}' value='#{fetch_nested_value(field['key'])}' placeholder='Enter your #{field['key']}'/>"
      when 'dropdown'
        options = fetch_nested_value(field['key']).map { |opt| "<option value='#{opt}'>#{opt}</option>" }.join("\n")
        "<label for='#{field['id']}'>#{field['label']}</label>
         <select id='#{field['id']}' class='#{field['class']}' name='#{field['key']}'>\n#{options}\n</select>"
      when 'datetime-local'
        disabled_attr = field['disabled'] ? 'disabled' : ''
        "<label for='#{field['id']}'>#{field['label']}</label>
         <input type='datetime-local' id='#{field['id']}' class='#{field['class']}' name='#{field['key']}' value='#{fetch_nested_value(field['key'])}' #{disabled_attr} />"
      when 'radio'
        options = field['options'].map { |opt| "<input type='radio' id='#{field['id']}_#{opt['value']}' class='#{field['class']}' name='#{field['key']}' value='#{opt['value']}'><label for='#{field['id']}_#{opt['value']}'>#{opt['label']}</label>" }.join("<br>")
        "<fieldset>
           <legend>#{field['label']}</legend>
           #{options}
         </fieldset>"
      else
        ''
      end
    end

    def fetch_nested_value(key)
      keys = key.split('.')
      keys.reduce(@data_json) do |data, k|
        return '' unless data.is_a?(Hash) && data.key?(k)
        data[k]
      end
    end
    

    def filter_and_sort_template
      <<-SLIM
        div
          button onclick='showFilterPanel()' Filter
          select name='sort'
            - @config_json['sort'].each do |sort_option|
              option value=sort_option['key'] = sort_option['label']
          div id='filterPanel' style='display:none;'
            - @config_json['filter'].each do |filter_option|
              label = filter_option['label']
              input type='checkbox' name=filter_option['key']
          button type='submit' Apply
      SLIM
    end

    def table_template
      <<-SLIM
        table
          tr
            th Select
            - @table_fields_yaml.each do |field|
              th id='#{field['id']}' class='#{field['class']}'= field['label']
          - data.each do |entry|
            tr
              td
                input type='checkbox' class='select-row'
              - @table_fields_yaml.each do |field|
                td id='#{field['id']}' class='#{field['class']}'= entry.dig(*field['key'].split('.'))
        button id='edit-button' style='display:none;' Edit
      SLIM
    end    
  end
end
