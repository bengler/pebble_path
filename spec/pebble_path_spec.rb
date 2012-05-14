require 'pebble_path'

class Thing
  def self.scope(*attrs)
  end
  def self.after_initialize(*attrs)
  end
  def self.validates_presence_of(*attrs)
  end
  def self.validate(*attrs)
  end

  (0..9).each do |i|
    attr_accessor "label_#{i}".to_sym
  end

  include PebblePath
end

describe PebblePath do
  subject do
    thing = Thing.new
    thing.path = "a.b.c.d.e"
    thing
  end

  describe "path" do

    it "accepts an array" do
      subject.path = %w(a b c)
      "#{subject.path}".should eq("a.b.c")
    end

    it "accepts a string" do
      subject.path = "a.b.c"
      "#{subject.path}".should eq("a.b.c")
    end

    it "doesn't do weird stuff" do
      subject.path = [nil, 'a']
      "#{subject.path}".should eq("")
    end

    specify { subject.path.map{|label| label + label}.should eq %w(aa bb cc dd ee) }

    specify { subject.path[1].should eq('b') }

    specify do
      subject.path[2] = 'x'
      "#{subject.path}".should eq("a.b.x.d.e")
    end

    its(:label_0) { should eq('a') }
    its(:label_1) { should eq('b') }
    its(:label_2) { should eq('c') }
    its(:label_3) { should eq('d') }
    its(:label_4) { should eq('e') }

    [:label_5, :label_6, :label_7, :label_8, :label_9].each do |attribute|
      it "hasn't filled #{attribute}" do
        subject.send(attribute).should be_nil
      end
    end
  end

  describe "overwrites labels" do
    before(:each) do
      subject.path = 'a.b.c'
    end

    its(:label_0) { should eq('a') }
    its(:label_1) { should eq('b') }
    its(:label_2) { should eq('c') }

    [:label_3, :label_4, :label_5, :label_6, :label_7, :label_8, :label_9].each do |attribute|
      it "overwrites #{attribute}" do
        subject.send(attribute).should be_nil
      end
    end
  end

  it "initializes path from label" do
    subject.path = []
    subject.label_0 = 'a'
    subject.label_1 = 'b'
    subject.label_2 = 'c'
    subject.path.to_s.should eq('')
    subject.initialize_path
    subject.path.to_s.should eq('a.b.c')
  end

  describe "no stray labels" do
    it "stops setting labels when it reaches a nil" do
      subject.path = ['a', 'b', nil, 'd']
      subject.path.to_s.should eq('a.b')
    end
  end
end
