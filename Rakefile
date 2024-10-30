# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

# Version check tasks
namespace :version do
  desc "Check the current version of the gem"
  task :check do
    version = File.read("lib/custom_form_generator/version.rb").match(/VERSION = "(.*)"/)[1]
    puts "Current version: #{version}"
  end

  desc "Update the version of the gem"
  task :update, [:new_version] do |_t, args|
    abort("Please provide a new version (e.g., rake version:update[new_version])") unless args[:new_version]
    new_version = args[:new_version]
    content = File.read("lib/custom_form_generator/version.rb")
    content.gsub!(/VERSION = "(.*)"/, "VERSION = \"#{new_version}\"")
    File.write("lib/custom_form_generator/version.rb", content)
    puts "Updated version to #{new_version}"
  end
end
