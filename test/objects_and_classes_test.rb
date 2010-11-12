require File.expand_path('../test_init.rb', __FILE__)

class Thing
  attr_accessor :a_field
  
  def public_method; "public"; end
  def protected_method; "protected"; end
  def private_method; "private"; end
  
  public :public_method
  protected :protected_method
  private :private_method
  
  public
  
  def call_other_protected(t); t.protected_method; end
  def call_other_private(t); t.private_method; end
end

class SubThing < Thing
  def call_super_protected; protected_method; end
  def call_super_private; private_method; end
end

class ObjectsAndClassesTest < Test::Unit::TestCase
  
  context "access control" do
    
    should "be able to list methods as arguments to control functions" do
      t = Thing.new
      assert_equal "public", t.public_method
      assert_raise(NoMethodError) { t.protected_method }
      assert_raise(NoMethodError) { t.private_method } 
    end
  
    should "be able to call super protected and private from subclass" do
      t = SubThing.new
      assert_equal "protected", t.call_super_protected
      assert_equal "private", t.call_super_private
    end
        
    should "be able to call protected of other instance of same class" do
      t = Thing.new; t2 = Thing.new
      assert_equal "protected", t.call_other_protected(t2)
    end
    
    should "not be able to call private of other instance of same class" do
      t = Thing.new; t2 = Thing.new
      assert_raise(NoMethodError) { t.call_other_private(t2) }
    end
    
  end
  
  context "Freezing" do
    
    should "should not be able to change things in frozen object" do
      t = Thing.new
      t.a_field = :a
      t.freeze
      assert_raise(RuntimeError) { t.a_field = :b }
    end
    
  end
  
end
