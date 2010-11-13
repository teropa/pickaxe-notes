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

class Thingamajigs
  include Enumerable
  
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
    end
    
    should "support min and max when members mixin comparable" do
      t = Thingamajigs.new(1, 2, 3, 4)
      assert_equal Thingamajig.new(1), t.min
      assert_equal Thingamajig.new(4), t.max
    end
    
  end
  
end
