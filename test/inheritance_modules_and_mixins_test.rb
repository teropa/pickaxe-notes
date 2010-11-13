require_relative 'test_init'

class Parent
end
class Child < Parent
end

class Thingamajig
  include Comparable
  
  attr_reader :val
  
  def initialize(val)
    @val = val
  end
  
  def <=>(other)
    val <=> other.val
  end
end

module ValSummable
  def sum
    inject(0) { |r,v| r + v.val }
  end
end

class Thingamajigs
  include Enumerable
  include ValSummable
    
  def initialize(*vals)
    @vals = vals.map { |v| Thingamajig.new(v) }
  end
  
  def each(&block)
    @vals.each(&block)
  end
end

class InheritanceModulesAndMixinsTest < Test::Unit::TestCase
  
  context "inheritance" do
    
    should "return the superclass from superclass method" do
      assert_equal Parent, Child.superclass
      assert_equal Object, Parent.superclass
      assert_equal BasicObject, Object.superclass
      assert BasicObject.superclass.nil?
    end
    
  end
  
  context "comparable mixin" do
    
    should "support comparison ops" do
      t1 = Thingamajig.new(1)
      t2 = Thingamajig.new(2)
      t3 = Thingamajig.new(3)
      
      assert t1 < t2
      assert t2 > t1
      assert t1 <= t2
      assert t2.between?(t1, t3)
      assert !t1.between?(t2, t3)
    end
    
  end
  
  context "enumerable mixin" do
    
    should "support enumerable methods" do
      t = Thingamajigs.new(1, 2, 3, 4)
      
      assert_equal Thingamajig.new(1), t.to_enum.next
      assert_equal Thingamajig.new(3), t.find { |t| t.val == 3 }
      assert_equal [Thingamajig.new(3)], t.reject { |t| t.val != 3 }
      assert_equal 10, t.inject(0) { |r,t| r + t.val }
    end
    
    should "support min and max when members mixin comparable" do
      t = Thingamajigs.new(1, 2, 3, 4)
      assert_equal Thingamajig.new(1), t.min
      assert_equal Thingamajig.new(4), t.max
    end
    
  end
  
  context "custom mixin" do
    
    should "get sum when mixes in ValSummable" do
      t = Thingamajigs.new(1, 2, 3, 4)
      assert_equal 10, t.sum
    end
    
  end
  
  context "method resolution order" do
    
    Mixin1 = Module.new do
      def method_a; "mixin1"; end
      def method_b; "mixin2"; end
    end
    
    Mixin2 = Module.new do
      def method_a; "mixin2"; end
      def method_b; "mixin2"; end
    end
    
    SuperThing = Class.new do
      def method_a; "superthing"; end
      def method_b; "superthing"; end
      def method_c; "superthing"; end
    end
    
    Thing = Class.new(SuperThing) do
      include Mixin1
      include Mixin2
      def method_a; "thing"; end
    end
    
    should "use objects own method if found" do
      assert_equal "thing", Thing.new.method_a
    end
    
    should "use last mixed in if method not found in objects class" do
      assert_equal "mixin2", Thing.new.method_b
    end
    
    should "use from superclass if method not found in objects class or mixins" do
      assert_equal "superthing", Thing.new.method_c
    end
    
  end
  
  
end
