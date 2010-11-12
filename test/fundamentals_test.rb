require File.expand_path('../test_init.rb', __FILE__)

class UserTest < Test::Unit::TestCase

  context "The very fundamentals" do
    
    should "make an array of words" do
      assert_equal ["the", "quick", "brown", "fox"], %w(the quick brown fox)
    end
    
    should "make hashes with default values" do
      h = Hash.new(0)
      assert_equal 0, h[:a]
      h[:b] += 1
      assert_equal 1, h[:b]
    end
    
    should "reuse same value given in the hash constructor" do
      h = Hash.new([])
      h[:a] << "thing"
      assert_equal ["thing"], h[:a]
      assert_equal ["thing"], h[:b]
    end
    
    should "support the javascripty hash literal syntax new in 1.9" do
      h = {name: 'John', age: 77}
      assert_equal 'John', h[:name]
      assert_equal 77, h[:age]
    end
    
    should "support while as a statement modifier" do
      n = 2
      n = n*n while n < 256
      assert_equal 256, n 
    end
    
  end
  
end
