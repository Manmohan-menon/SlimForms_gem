module CustomFormGenerator
  module Helpers
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
end
