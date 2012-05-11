require 'pebble_path/positions'

module PebblePath

  attr_reader :path
  def path=(positions)
    @path = Positions.new(positions)

    path.all.each_with_index do |value, i|
      send(:"label_#{i}=", value)
    end
    path
  end

end
