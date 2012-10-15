require 'pebblebed'
require 'pebbles-uid'

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
      positions = truncate_invalid(positions)
      (0...MAX_DEPTH).map do |i|
        positions[i]
      end
    end

    def truncate_invalid(positions)
      labels = []
      (0...MAX_DEPTH).each do |i|
        break if positions[i].nil?
        labels << positions[i]
      end
      labels
    end

    class << self

      def to_conditions(path)
        unless Pebblebed::Uid.valid_path?(path)
          raise ArgumentError.new("Wildcards terminate the path. Invalid path: #{path}")
        end

        labels = Pebbles::Uid::Labels.new(path, :name => 'label', :max_depth => MAX_DEPTH, :stop => nil)
        labels.to_hash
      end
    end
  end

end
