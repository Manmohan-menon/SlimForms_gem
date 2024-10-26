# frozen_string_literal: true

require "cgi"

module CustomFormGenerator
  module Helpers
    # FormElementRenderer module handles HTML form element generation
    module FormElementRenderer
      def render_textfield(attrs)
        <<~HTML
          <label for='#{attrs[:id]}'>#{attrs[:label]}</label>
          <input type='text' id='#{attrs[:id]}' class='#{attrs[:css_class]}'#{" "}
                 name='#{attrs[:key]}' value='#{CGI.escapeHTML(attrs[:value])}'#{" "}
                 placeholder='Enter your #{attrs[:label]}'/>
        HTML
      end

      def render_dropdown(field, attrs)
        options = fetch_dropdown_options(field, attrs[:value])
        <<~HTML
          <label for='#{attrs[:id]}'>#{attrs[:label]}</label>
          <select id='#{attrs[:id]}' class='#{attrs[:css_class]}' name='#{attrs[:key]}'>
            #{options}
          </select>
        HTML
      end

      def render_datetime(field, attrs)
        disabled_attr = field["disabled"] ? "disabled" : ""
        <<~HTML
          <label for='#{attrs[:id]}'>#{attrs[:label]}</label>
          <input type='datetime-local' id='#{attrs[:id]}' class='#{attrs[:css_class]}'#{" "}
                 name='#{attrs[:key]}' value='#{CGI.escapeHTML(attrs[:value])}' #{disabled_attr} />
        HTML
      end

      def render_radio(field, attrs)
        options = fetch_radio_options(field, attrs[:value])
        <<~HTML
          <fieldset>
            <legend>#{attrs[:label]}</legend>
            #{options}
          </fieldset>
        HTML
      end

      def render_textbox(attrs)
        <<~HTML
          <label for='#{attrs[:id]}'>#{attrs[:label]}</label>
          <textarea id='#{attrs[:id]}' class='#{attrs[:css_class]}' name='#{attrs[:key]}'#{" "}
                    placeholder='Enter your #{attrs[:label]}'>#{CGI.escapeHTML(attrs[:value])}</textarea>
        HTML
      end
    end
  end
end
