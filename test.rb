# frozen_string_literal: true

require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::INFO

class Generation
  LIVE_SYMBOL = '*'
  DEAD_SYMBOL = '.'

  def initialize
    @number = 1
    @n_rows = 4
    @n_cols = 8
    @state = [
      [DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL],
      [DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, LIVE_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL],
      [DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, LIVE_SYMBOL, LIVE_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL],
      [DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL, DEAD_SYMBOL]
    ]
  end

  def get_neighbours_values(cell_row, cell_column)
    puts "Called get_neighbours_values on cell[#{cell_row}][#{cell_column}]"

    values = []
    rows_to_visit = [cell_row - 1, cell_row, cell_row + 1]
    columns_to_visit = [cell_column - 1, cell_column, cell_column + 1]

    rows_to_visit.each do |row_index|
      columns_to_visit.each do |column_index|
        if row_index == cell_row && column_index == cell_column
          # The cell itself is not a neighbour
          next
        end

        puts "Retrieving value of neighbour [#{row_index}][#{column_index}]"

        if row_index.negative? || row_index == @n_rows || column_index.negative? || column_index == @n_cols
          # the grid is finite and no life can exist off the edges
          values.append(DEAD_SYMBOL)
        else
          values.append(@state[row_index][column_index])
        end
      end
    end

    puts "Length: #{values.length}"
    raise 'Bad calculation of neighbours values' unless values.length == 8

    values
  end

  def calculate_next_cell_state(cell_row, cell_column)
    neighbours_values = get_neighbours_values(cell_row, cell_column)
    alive_cells = neighbours_values.reduce(0) do |alive_cells, cell_state|
      cell_state == LIVE_SYMBOL ? alive_cells + 1 : alive_cells
    end

    cell_state = @state[cell_row][cell_column]
    new_state = nil

    new_state = if cell_state == DEAD_SYMBOL
                  # Any dead cell with exactly three live neighbours becomes a live cell
                  if alive_cells == 3
                    LIVE_SYMBOL
                  else
                    DEAD_SYMBOL
                  end
                elsif alive_cells < 2 # live cell
                  # Any live cell with fewer than two live neighbours dies
                  DEAD_SYMBOL
                  # Any live cell with more than three live neighbours dies
                elsif alive_cells > 3
                  DEAD_SYMBOL
                else
                  # Any live cell with two or three live neighbours lives on to the next generation
                  LIVE_SYMBOL
                end

    raise 'Bad calculation of next cell state' if new_state.nil?

    new_state
  end

  def calculate_next_generation
    (0...@n_rows).each do |row_index|
      (0...@n_cols).each do |column_index|
        @state[row_index][column_index] = calculate_next_cell_state(row_index, column_index)
      end
    end

    @number += 1
  end

  def to_s
    s = "Generation #{@number}\n#{@n_rows} #{@n_cols}\n"
    @state.each do |row|
      row.each do |column|
        s += "#{column} "
      end
      s += "\n"
    end
    s
  end
end

if __FILE__ == $PROGRAM_NAME
  generation = Generation.new
  puts generation
  generation.calculate_next_generation
  puts generation
end
