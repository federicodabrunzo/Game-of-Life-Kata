# frozen_string_literal: true

def generate_random_matrix(rows, cols, symbols)
  raise 'symbols must be iterable' unless symbols.respond_to?('sample')

  Array.new(rows) { |_i| Array.new(cols) { symbols.sample } }
end
