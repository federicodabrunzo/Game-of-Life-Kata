# frozen_string_literal: true

require 'logger'
require_relative '../config/settings'
require_relative 'utils'

logger = Logger.new($stdout)
logger.level = Logger::INFO

class Generation
  HEADER_LINES = 2

  def initialize(number: GENERATION_NUMBER, n_rows: N_ROWS, n_cols: N_COLS,
                 live_symbol: LIVE_SYMBOL, dead_symbol: DEAD_SYMBOL,
                 initial_state: nil, initial_state_path: nil)

    raise "Can't specify initial_state_path if initial_state is specified" if initial_state && initial_state_path

    @live_symbol = live_symbol
    @dead_symbol = dead_symbol

    if initial_state_path
      @state = initialize_from_file(initial_state_path)
    else
      @number = number
      @n_rows = n_rows
      @n_cols = n_cols
      @state = initial_state.nil? ? generate_random_matrix(n_rows, n_cols, [live_symbol, dead_symbol]) : initial_state
    end

    validate_grid
  end

  def initialize_from_file(path)
    generation_number = nil
    n_rows = nil
    n_cols = nil
    initial_state = nil

    File.readlines("#{Bundler.root}/#{path}").each_with_index do |line, index|
      line = line.strip

      if index.zero?
        raise 'Bad input format. Expected "Generation <n>:" as first line.' unless line.match(/^Generation [0-9]+:$/)

        generation_number = line.split(' ')[1].gsub(':', '').to_i
        next
      end

      if index == 1
        raise 'Bad input format. Expected "<n> <n>" as second line.' unless line.match(/^[0-9]+\s[0-9]+$/)

        n_rows, n_cols = line.split(" ").map { |digits| digits.to_i }
        initial_state = generate_empty_matrix(n_rows, n_cols)
        next
      end

      raise "Bad row format. (#{line})" unless line.match(/^[*\\.]{#{n_cols}}$/)

      line.split('').each_with_index do |symbol, line_char_index|
        initial_state[index - HEADER_LINES][line_char_index] = symbol == '*' ? LIVE_SYMBOL : DEAD_SYMBOL
      end
    end

    @number = generation_number
    @n_rows = n_rows
    @n_cols = n_cols
    @state = initial_state
  end

  def validate_grid
    if @state.length != @n_rows
      err_msg = "Invalid grid. Grid number of rows (#{@state.length}) don't match the expected of #{@n_rows}"
      raise err_msg
    end

    @state.each_with_index do |row, row_index|
      if row.length != @n_cols
        err_msg = "Invalid grid. (Row #{row_index}) Number of columns (#{row.length}) don't match the expected of #{@n_cols}"
        raise err_msg
      end
      row.each do |cell|
        if cell != @live_symbol && cell != @dead_symbol
          raise "Invalid grid. Found unexpected symbol '#{cell}' in row #{row_index} (#{row})"
        end
      end
    end
  end

  def get_neighbours_values(cell_row, cell_column)
    # puts "Called get_neighbours_values on cell[#{cell_row}][#{cell_column}]"

    values = []
    rows_to_visit = [cell_row - 1, cell_row, cell_row + 1]
    columns_to_visit = [cell_column - 1, cell_column, cell_column + 1]

    rows_to_visit.each do |row_index|
      columns_to_visit.each do |column_index|
        if row_index == cell_row && column_index == cell_column
          # The cell itself is not a neighbour
          next
        end

        # puts "Retrieving value of neighbour [#{row_index}][#{column_index}]"

        if row_index.negative? || row_index == @n_rows || column_index.negative? || column_index == @n_cols
          # the grid is finite and no life can exist off the edges
          values.append(@dead_symbol)
        else
          values.append(@state[row_index][column_index])
        end

        # puts values
      end
    end

    # puts "Length: #{values.length}"
    raise 'Bad calculation of neighbours values' unless values.length == 8

    values
  end

  def calculate_next_cell_state(cell_row, cell_column)
    neighbours_values = get_neighbours_values(cell_row, cell_column)
    alive_cells = neighbours_values.reduce(0) do |alive_cells, cell_state|
      cell_state == @live_symbol ? alive_cells + 1 : alive_cells
    end

    cell_state = @state[cell_row][cell_column]
    new_state = nil

    new_state = if cell_state == @dead_symbol
                  # Any dead cell with exactly three live neighbours becomes a live cell
                  if alive_cells == 3
                    @live_symbol
                  else
                    @dead_symbol
                  end
                elsif [2, 3].include?(alive_cells)
                  # Any live cell with two or three live neighbours lives on to the next generation
                  @live_symbol
                else
                  # Any live cell with fewer than two live neighbours dies
                  # Any live cell with more than three live neighbours dies
                  @dead_symbol
                end

    raise 'Bad calculation of next cell state' if new_state.nil?

    new_state
  end

  def get_alive_cells_number
    value = 0

    @state.each do |row|
      row.each do |column|
        value += 1 if column == @live_symbol
      end
    end

    value
  end

  def calculate_next_generation
    new_state = generate_empty_matrix(@n_rows, @n_cols)

    (0...@n_rows).each do |row_index|
      (0...@n_cols).each do |column_index|
        new_state[row_index][column_index] = calculate_next_cell_state(row_index, column_index)
      end
    end

    @number += 1
    @state = new_state
  end

  def to_s
    s = "Generation #{@number}\n#{@n_rows} #{@n_cols}\n"
    m_str = matrix_to_str(@state)

    s += m_str
  end
end
