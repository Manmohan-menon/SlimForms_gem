# frozen_string_literal: true

require_relative "custom_form_generator/version"
require 'json'
require 'slim'
require 'yaml'
require_relative "custom_form_generator/generator"

module CustomFormGenerator
  class Error < StandardError; end
end