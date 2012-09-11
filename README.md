# PebblePath

Provides searchable, parseable pebbles-compliant UID paths, e.g. (such as `a.b.*`) for Active Record models.

## Requirements

Requires ActiveModel. The target class (the one that will contain the `path` property) needs to have fields in the DB for:

```
label_0
label_1
label_2
label_3
label_4
label_5
label_6
label_7
label_8
label_9
```

## Installation

Add this line to your application's Gemfile:

    gem 'pebble_path'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pebble_path

Create a migration for the table that you want to put the paths on, e.g.

    def self.up
      labels = (0..9).map { |i| "label_#{i}".to_sym }

      create_table :locations do |t|
        labels.each do |label|
          t.text label
        end
        t.timestamps
      end

      add_index :locations, labels, :unique => true, :name => 'index_locations_on_labels'
    end


## Usage

Include the `PebblePath` module in the `ActiveRecord` model that has the labels

```
class Location < ActiveRecord::Base
  include PebblePath
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
