module CustomFormGenerator
  module Helpers
    module FilterSort
      def filter_and_sort_template(updated_config)
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

        config
      end
    end
  end
end
