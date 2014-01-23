class Cell
  attr_reader :location, :neighbors

  def initialize(args = {})
    @alive = args.fetch(:alive) { false }
    @alive_last_turn = args.fetch(:alive_last_turn) { false }
    @location = args.fetch(:location) { {x: 0, y: 0} }
    @neighbors = {}
  end

  def alive?
    @alive
  end

  def kill
    @alive = false
  end

  def revive
    @alive = true
  end

  def alive_last_turn?
   @alive_last_turn
  end

  def set_alive_last_turn
   @alive_last_turn = @alive
  end

  def living_neighbors
    neighbors.select { |location, cell| cell.alive_last_turn? }.size
  end

  def to_s
    "#{location[:x]}:#{location[:y]} - #{alive? ? "Living" : "Dead"} - #{ neighbors.size } Neighbors"
  end

  def to_neighbors
    neighbors.each do |location, cell|
      puts location.to_s + " - " + cell.to_s
    end
    puts ""
  end
end
