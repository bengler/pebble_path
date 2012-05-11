require 'pebblebed'

module PebblePath
  class Positions
    include Enumerable

    MAX_DEPTH = 10

    attr_reader :labels, :all
    def initialize(positions)
      @all = resolve positions
      @labels = all.compact
    end

    def each
      labels.each {|label| yield label}
    end

    def [](index)
      labels[index]
    end

    def []=(index, value)
      labels[index] = value
    end

    def to_s
      labels.join('.')
    end

    def resolve(positions)
      positions = positions.split('.') if positions.is_a?(String)
      (0...MAX_DEPTH).map { |i| positions[i] }
    end
  end
end
