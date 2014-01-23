require_relative './cell.rb'
require 'debugger'

class World
  DIRECTIONS = { left:      {x: -1, y: 0},
                 upleft:    {x: -1, y: 1},
                 up:        {x: 0, y: 1},
                 upright:   {x: 1, y: 1},
                 right:     {x: 1, y: 0},
                 downright: {x: 1, y: -1},
                 down:      {x: 0, y: -1},
                 downleft:  {x: -1, y: -1}
               }

  attr_reader :cells, :new_cells

  def initialize(coordinates = "")
    create_cells(coordinates)
  end

  def create_cells(coordinates)
    @cells = {}
    @new_cells = {}
    coordinates.split(",").each do |coordinate|
      coordinate = coordinate.split(":")
      location = {x: coordinate[0].to_i, y: coordinate[1].to_i}
      cells[location] = Cell.new(location: location, alive: true)
    end
  end

  def get_cell(location, only_existing = false)
    cell = cells[location]
    cell = new_cells[location] unless cell
    unless cell || only_existing
      cell = Cell.new(location: location)
      new_cells[location] = cell
    end
    cell
  end

  def get_new_cells
    cells.each_value do |cell|
      find_neighbors(cell) if cell.alive? && cell.neighbors.size < 8
    end
    combine_cells
  end

  def find_all_neighbors
    cells.each_value { |cell| find_neighbors(cell, true) }
  end

  def find_neighbors(cell, only_existing = false)
    DIRECTIONS.each do |direction, amount|
      unless cell.neighbors[direction]
        new_location = modify(cell.location, amount)
        a_cell = get_cell(new_location, only_existing)
        cell.neighbors[direction] = a_cell if a_cell
      end
    end
  end

  def update_cell(cell)
    living_neighbors = cell.living_neighbors
    cell.kill if living_neighbors < 2 || living_neighbors > 3
    cell.revive if living_neighbors == 3
  end

  def set_alive_last_turn
    cells.each_value { |cell| cell.set_alive_last_turn }
  end

  def next_turn
    get_new_cells
    find_all_neighbors
    set_alive_last_turn
    cells.each_value { |cell| update_cell(cell) }
  end

  def combine_cells
    new_cells.each do |location, cell|
      cells[location] = cell
    end
    @new_cells = {}
  end

  def modify(location, amount)
    new_location = {}
    location.each_key { |i| new_location[i] = location[i] + amount[i] }
    new_location
  end

  def to_s
    string = ""
    (-20..20).each do |i|
      (-80..80).each do |j|
        if get_cell(x: j, y: i).alive?
          string += "X"
        else
          string += "."
        end
      end
      string += "\n"
    end
    string
  end

  def start
    continue = true
    last = ""
    while continue
      print "\e[2J"
      print "\e[H"
      puts self
      next_turn
      gets
    end
  end

  def to_string
    string = ""
    cells.each do |location, cell|
      string += cell.to_s + "\n"
    end
    string
  end
end
