require 'spec_helper'
require_relative '../lib/world.rb'

describe World do
  it "can be created with a string of location pairs" do
    world = World.new("-1:0,0:0,1:0")
    expect( world.get_cell(x: -1, y: 0).class ).to eq Cell
    expect( world.get_cell(x: 0, y: 0).class ).to eq Cell
    expect( world.get_cell(x: 1, y: 0).class ).to eq Cell
  end

  it "can get a cell at a particular location" do
    world = World.new("0:0")
    cell = Cell.new(location: {x: 1, y: 1}, alive: true)
    world.cells[cell.location] = cell
    expect( world.get_cell(x: 1, y: 1) ).to be cell
  end

  it "can create a cell at a particular location if it doesn't exist" do
    cell = World.new.get_cell(x: 0, y: 0)
    location = {x: 0, y: 0}
    expect( cell.location ).to eq location
    expect( cell.alive? ).to be_false
  end

  it "can find/create and set the neighbors for all living cells" do
    world = World.new("-1:0,0:0,1:0")
    world.get_new_cells
    expect( world.cells.size ).to be 15
  end

  it "can find all the existent neighbors for current cells" do
    world = World.new("-1:0,0:0,1:0")
    world.get_new_cells
    world.find_all_neighbors
    expect( world.cells.size ).to be 15
    world.cells.each_value do |cell|
      expect( cell.living_neighbors > 0)
    end
  end

  it "kills a cell if it has less than two living neighbors" do
    world = World.new("-1:0,0:0")
    cell = world.get_cell(x: 0, y: 0)
    world.set_alive_last_turn
    world.find_neighbors(cell)
    world.update_cell(cell)
    expect( cell.alive? ).to be_false
  end

  it "kills a cell if it has more than three living neighbors" do
    world = World.new("-1:0,0:0,0:1,1:0,0:-1")
    cell = world.get_cell(x: 0, y: 0)
    world.set_alive_last_turn
    world.find_neighbors(cell)
    world.update_cell(cell)
    expect( cell.alive? ).to be_false
  end

  it "revives a dead cell if it has exactly three living neighbors" do
    world = World.new("-1:0,0:0,0:1,1:0")
    cell = world.get_cell(x: 0, y: 0)
    cell.kill
    world.set_alive_last_turn
    world.find_neighbors(cell)
    world.update_cell(cell)
    expect( cell.alive? ).to be_true
  end

  it "updates the status of all cells each turn" do
    world = World.new("-1:0,0:0,0:1,1:0")
    cell_one = world.get_cell(x: 0, y: 0)
    cell_two = world.get_cell(x: -1, y: 0)
    world.get_new_cells
    cell_one.kill
    world.next_turn
    expect( cell_one.alive? ).to be_true
    expect( cell_two.alive? ).to be_false
  end

  it "sets the value of alive_last_turn? for every cell" do
    world = World.new("0:0")
    world.set_alive_last_turn
    expect( world.get_cell(x: 0, y: 0).alive_last_turn? ).to be_true
  end
end
