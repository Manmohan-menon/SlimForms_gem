# frozen_string_literal: true

require_relative "custom_form_generator/version"
require 'json'
require 'slim'

module CustomFormGenerator
  class Error < StandardError; end
  class Generator
    def initialize(form_json, data_json, config_json)
      @form_json = JSON.parse(File.read(form_json))
      @data_json = JSON.parse(File.read(data_json))
      @config_json = JSON.parse(File.read(config_json))
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
  - @form_json.each do |field|
    == render_field(field)
    br
      SLIM
    end

    def render_field(field)
      case field['type']
      when 'textfield'
        "<label>#{field['label']}</label><input type='text' name='#{field['key']}' value='#{@data_json[field['key']]}' placeholder='Enter your #{field['key']}'/>"
      when 'dropdown'
        options = @data_json[field['key']].map { |opt| "<option value='#{opt}'>#{opt}</option>" }.join("\n")
        "<label>#{field['label']}</label><select name='#{field['key']}'>\n#{options}\n</select>"
      else
        ''
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
    - @form_json.each do |field|
      th= field['label']
  - data.each do |entry|
    tr
      - @form_json.each do |field|
        td= entry[field['key']]
      SLIM
    end
  end
end
