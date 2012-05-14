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

    class << self

      def detect(path)
        unless Pebblebed::Uid.valid_path?(path)
          raise ArgumentError.new("Wildcards terminate the path. Invalid path: #{path}")
        end

        labels = path.split('.')
        # In a Pebblebed::Uid::WildcardPath, anything after '^' is optional.
        optional_part = false

        labels.map! do |label|
          if label =~ /^\^/
            label.gsub!(/^\^/, '')
            optional_part = true
          end

          result = label.include?('|') ? label.split('|') : label
          result = [label, nil].flatten if optional_part
          result
        end

        result = {}
        (0...MAX_DEPTH).map do |index|
          break if labels[index] == '*'
          result[:"label_#{index}"] = labels[index]
          break if labels[index].nil?
        end
        result
      end

    end
  end

end
