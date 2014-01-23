require 'spec_helper'
require_relative '../lib/cell.rb'

describe Cell do
  it "is created dead by default" do
    expect( Cell.new.alive? ).to be false
  end

  it "can be created either alive or dead" do
  	expect( Cell.new(alive: true).alive? ).to be_true
  	expect( Cell.new(alive: false).alive? ).to be_false
  end

  it "has a location of 0:0 by default" do
    location = {x: 0, y: 0}
    expect( Cell.new.location ).to eq location
  end

  it "can be created at a specific location" do
    location = {x: 0, y: 1}
    expect( Cell.new(location: {x: 0, y: 1}).location ).to eq location
  end

  it "can be killed if it is alive" do
    cell = Cell.new(alive: true)
    cell.kill
    expect( cell.alive? ).to be_false
  end

  it "can be revived if it is dead" do
    cell = Cell.new(alive: false)
    cell.revive
    expect( cell.alive? ).to be_true
  end

  it "knows whether it was alive or dead last turn" do
    expect( Cell.new.alive_last_turn? ).to be_false
  end

  it "sets whether it was alive or dead last turn" do
    cell = Cell.new
    cell.set_alive_last_turn
    cell.revive
    expect( cell.alive_last_turn? ).to be_false
  end

  it "can be told where its neighbors are" do
    cell = Cell.new
    left_cell = Cell.new
    cell.neighbors[:left] = left_cell
    expect( cell.neighbors[:left] ).to eq left_cell
  end

  it "knows how many living neighbors it has" do
    cell = Cell.new
    cell.neighbors[:left] = Cell.new(alive: true, alive_last_turn: true, location: {x: 0, y: 1})
    cell.neighbors[:right] = cell.neighbors[:left]
    expect( cell.living_neighbors ).to be 2
  end
end