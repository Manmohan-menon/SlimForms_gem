module CustomFormGenerator
  module Helpers
    module FieldRenderers
      def render_field(field)
        label = CGI.escapeHTML(field['label'])
        id = CGI.escapeHTML(field['id'])
        key = CGI.escapeHTML(field['key'])
        css_class = CGI.escapeHTML(field['class'])
        value = fetch_nested_value(field['key']).to_s
        escaped_value = CGI.escapeHTML(value)

        case field['type']
        when 'textfield'
          "<label for='#{id}'>#{label}</label>
          <input type='text' id='#{id}' class='#{css_class}' name='#{key}' value='#{escaped_value}' placeholder='Enter your #{label}'/>"
        when 'dropdown'
          options = fetch_dropdown_options(field, value)
          "<label for='#{id}'>#{label}</label>
          <select id='#{id}' class='#{css_class}' name='#{key}'>\n#{options}\n</select>"
        when 'datetime-local'
          disabled_attr = field['disabled'] ? 'disabled' : ''
          "<label for='#{id}'>#{label}</label>
          <input type='datetime-local' id='#{id}' class='#{css_class}' name='#{key}' value='#{escaped_value}' #{disabled_attr} />"
        when 'radio'
          options = fetch_radio_options(field, value)
          "<fieldset>
            <legend>#{label}</legend>
            #{options}
          </fieldset>"
        when 'textbox'
          "<label for='#{id}'>#{label}</label>
          <textarea id='#{id}' class='#{css_class}' name='#{key}' placeholder='Enter your #{label}'>#{escaped_value}</textarea>"
        else
          ''
        end
      end

      def fetch_dropdown_options(field, selected_value)
        options = fetch_nested_value(field['key'])
        return '' unless options.is_a?(Array)
      
        options.map { |opt|
          selected = (opt == selected_value) ? 'selected' : ''
          "<option value='#{CGI.escapeHTML(opt)}' #{selected}>#{CGI.escapeHTML(opt)}</option>"
        }.join("\n")
      end
      
      def fetch_radio_options(field, selected_value)
        field['options'].map { |opt|
          opt_value = CGI.escapeHTML(opt['value'])
          opt_label = CGI.escapeHTML(opt['label'])
          checked = (opt['value'] == selected_value) ? 'checked' : ''
          "<input type='radio' id='#{id}_#{opt_value}' class='#{css_class}' name='#{key}' value='#{opt_value}' #{checked}><label for='#{id}_#{opt_value}'>#{opt_label}</label>"
        }.join("<br>")
      end

      def fetch_nested_value(key)
        keys = key.split('.')
        value = keys.reduce(@data_json) do |data, k|
          return '' unless data.is_a?(Hash) && data.key?(k)
          data[k]
        end
        puts "DEBUG: key = #{key}, value = #{value.inspect}" if @debug
        value.is_a?(Array) ? value : value || ''
      end
    end
  end
end
