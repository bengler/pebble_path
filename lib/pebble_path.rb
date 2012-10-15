require 'pebble_path/positions'

module PebblePath

  def self.max_depth
    Positions::MAX_DEPTH
  end

  def self.to_conditions(paths)
    Positions.to_conditions(paths)
  end

  def self.included(base)
    base.class_eval do
      scope :by_path, lambda { |path|
        where Positions.to_conditions(path)
      }

      validates_presence_of :label_0
      validate :must_be_valid_uid_path

      after_initialize :initialize_path

      def self.declare!(path)
        raise ArgumentError, "Path must be valid" unless Pebbles::Uid.valid_path?(path)
        attributes = PebblePath.to_conditions(path)
        path = self.where(attributes).first
        path ||= self.create!(attributes)
      end

    end
  end

  attr_reader :path
  def path=(positions)
    @path = Positions.new(positions)

    path.all.each_with_index do |value, i|
      send(:"label_#{i}=", value)
    end
    path
  end

  def initialize_path
    positions = []
    [:label_0, :label_1, :label_2, :label_3, :label_4, :label_5, :label_6, :label_7, :label_8, :label_9].each do |attribute|
      positions << send(attribute)
    end
    self.path = positions
  end

  def must_be_valid_uid_path
    unless Pebbles::Uid.valid_path?(self.path.to_s)
      errors.add(:base, "Location path '#{self.path.to_s}' is invalid.")
    end
  end

end
