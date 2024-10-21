module CustomFormGenerator
  module Helpers
    module YamlLoader
      def load_yaml(file_path)
        YAML.load_file(file_path)
      rescue StandardError => e
        raise CustomFormGenerator::Error, "Failed to load YAML file #{file_path}: #{e.message}"
      end
    end
  end
end
