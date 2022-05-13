# frozen_string_literal: true

require_relative 'generation'
require_relative 'utils'
require_relative '../config/settings'

if __FILE__ == $PROGRAM_NAME
  generation = Generation.new(initial_state_path: INITIAL_STATE_PATH)

  loop do
    puts generation
    sleep(NEXT_GENERATION_DELAY_SECS)
    generation.calculate_next_generation
  end
end
