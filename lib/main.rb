# frozen_string_literal: true

require_relative 'generation'

if __FILE__ == $PROGRAM_NAME
  generation = Generation.new
  puts generation
  generation.calculate_next_generation
  puts generation
end
