# frozen_string_literal: true

def matrix_to_str(m)
  s = ''

  m.each do |row|
    row.each do |column|
      s += "#{column} "
    end
    s += "\n"
  end

  s
end

def generate_empty_matrix(rows, cols)
  Array.new(rows) { |_i| Array.new(cols) { nil } }
end

def generate_random_matrix(rows, cols, symbols)
  raise 'symbols must be iterable' unless symbols.respond_to?('sample')

  Array.new(rows) { |_i| Array.new(cols) { symbols.sample } }
end
