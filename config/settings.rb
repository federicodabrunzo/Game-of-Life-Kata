# frozen_string_literal: true
require 'logger'

PROJECT_ROOT = Bundler.root

# Generation default values if you don't specify an initial state
GENERATION_NUMBER = 1
N_ROWS = 4
N_COLS = 8
LIVE_SYMBOL = '*'
DEAD_SYMBOL = '.'

# Relative project filepath with the initial generation cells
INITIAL_STATE_PATH = 'samples/blinker.txt'

NEXT_GENERATION_DELAY_SECS = 1

LOGGER = Logger.new("#{PROJECT_ROOT}/logs/generation_app.log")
LOGGER.level = Logger::DEBUG

begin
  require_relative 'local_settings'
rescue StandardError
end
