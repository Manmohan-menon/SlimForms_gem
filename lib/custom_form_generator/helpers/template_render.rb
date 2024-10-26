# frozen_string_literal: true

require "slim"
require "cgi"

module CustomFormGenerator
  module Helpers
    # TemplateRender module handles rendering of Slim templates.
    # Provides methods to generate dynamic HTML content for form
    # based on the provided configuration and data.
    module TemplateRender
      def form_template
        <<-SLIM
          form
            - @form_yaml.each do |field|
              - next if field['key'] == '_id'
              == render_field(field)
              br
        SLIM
      end

      def filter_and_sort_template(_config)
        <<-SLIM
          div
            button onclick='showFilterPanel()' Filter
            select name='sort'
              - config['sort'].each do |sort_option|
                option value=sort_option['key'] = sort_option['label']
            select name='order_by'
              - config['order_by'].each do |order_option|
                option value=order_option['key'] = order_option['label']
            div id='filterPanel' style='display:none;'
              - config['filter'].each do |filter_option|
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
    end
  end
end
