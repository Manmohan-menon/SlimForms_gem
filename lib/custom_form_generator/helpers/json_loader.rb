# frozen_string_literal: true

require "json"
puts "JSON Version: #{JSON::VERSION}"

module CustomFormGenerator
  module Helpers
    # JsonLoader module provides JSON file loading functionality with safety checks
    # along with error handling for the CustomFormGenerator gem
    module JsonLoader
      def load_json(file_path)
        raise CustomFormGenerator::Error, "JSON file not found: #{file_path}" unless File.exist?(file_path)

        JSON.parse(File.read(file_path))
      end
    end
  end
end
