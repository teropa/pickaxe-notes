require File.expand_path('../test_init.rb', __FILE__)

class Thing
  def public_method; "public"; end
  def protected_method; "protected"; end
  def private_method; "private"; end
  
  public :public_method
  protected :protected_method
  private :private_method
  
  public
  
  def call_other_protected(t)
    t.protected_method
  end
  
  def call_other_private(t)
    t.private_method
  end
  
end

class SubThing < Thing
  def call_super_protected; protected_method; end
  def call_super_private; private_method; end
end

class ObjectsAndClassesTest < Test::Unit::TestCase
  
  context "access control" do
    
    should "be able to list methods as arguments to control functions" do
      t = Thing.new
      t.public_method
      assert_raise(NoMethodError) { t.protected_method }
      assert_raise(NoMethodError) { t.private_method } 
    end
  
    should "be able to call super protected and private from subclass" do
      t = SubThing.new
      assert "protected", t.call_super_protected
      assert "private", t.call_super_protected
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
  
end
