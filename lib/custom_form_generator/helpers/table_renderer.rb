# frozen_string_literal: true

require "slim"
module CustomFormGenerator
  module Helpers
    # Module CustomFormGenerator::Helpers::TableRenderer helps in gnerating table from yaml using slim template
    module TableRenderer
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

      def generate_tabular_view(data:, table_template:)
        template = Slim::Template.new { table_template }
        template.render(self, data: data)
      end
    end
  end
end
