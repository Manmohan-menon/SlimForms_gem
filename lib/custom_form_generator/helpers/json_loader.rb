module CustomFormGenerator
  module Helpers
    module JsonLoader
      def load_json(file_path)
        JSON.parse(File.read(file_path))
      rescue StandardError => e
        raise CustomFormGenerator::Error, "Failed to load JSON file #{file_path}: #{e.message}"
      end
    end
  end
end
