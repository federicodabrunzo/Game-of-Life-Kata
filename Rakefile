# frozen_string_literal: true

require "rspec/core/rake_task"

task default: %w[run]

RSpec::Core::RakeTask.new(:spec)

task :run do
  ruby 'lib/main.rb'
end

task :console do
  ruby 'bin/console'
end
