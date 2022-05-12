# frozen_string_literal: true

GENERATION_NUMBER = 1
N_ROWS = 4
N_COLS = 8
LIVE_SYMBOL = '*'
DEAD_SYMBOL = '.'

begin
  require_relative 'local_settings'
rescue StandardError
end
