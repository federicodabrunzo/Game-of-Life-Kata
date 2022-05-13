# frozen_string_literal: true

require_relative '../lib/generation'

describe Generation do
  context 'When passing a correct state matrix' do
    generation_number = 1
    n_rows = 4
    n_cols = 8
    live_symbol = '*'
    dead_symbol = '.'
    initial_state = [
      [dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol],
      [dead_symbol, dead_symbol, dead_symbol, dead_symbol, live_symbol, dead_symbol, dead_symbol, dead_symbol],
      [dead_symbol, dead_symbol, dead_symbol, live_symbol, live_symbol, dead_symbol, dead_symbol, dead_symbol],
      [dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol, dead_symbol]
    ]

    it 'should have the correct number of alive cells in the next generation' do
      generation = Generation.new(
        number: generation_number,
        n_rows: n_rows,
        n_cols: n_cols,
        live_symbol: live_symbol,
        dead_symbol: dead_symbol,
        initial_state: initial_state
      )
      generation.calculate_next_generation
      expect(generation.get_alive_cells_number).to be 4
    end
  end
end
