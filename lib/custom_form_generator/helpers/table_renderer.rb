module CustomFormGenerator
  module Helpers
    module TableRenderer
      def generate_tabular_view(data)
        Slim::Template.new { table_template }.render(self, data: data)
      end
    end
  end
end
