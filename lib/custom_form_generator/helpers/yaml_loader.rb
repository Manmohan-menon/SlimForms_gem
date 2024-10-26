# frozen_string_literal: true

require "yaml"
module CustomFormGenerator
  module Helpers
    # YamlLoader module provides YAML file loading functionality with safety checks
    # along with error handling for the CustomFormGenerator gem
    module YamlLoader
      def load_yaml(file_path)
        raise CustomFormGenerator::Error, "YAML file not found: #{file_path}" unless File.exist?(file_path)

        YAML.safe_load(File.read(file_path), permitted_classes: [Symbol])
      end
    end
  end
end
