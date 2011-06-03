require_relative 'test_init'

class FundamentalsTest < Test::Unit::TestCase

  context "The very fundamentals" do
    
    should "make an array of words with %w" do
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
  
  context "Regex fundamentals" do
    
    should "return index of match from =~" do
      assert_equal 1, "John" =~ /o/
    end
    
    should "return nil from =~ when not matched" do
      assert_nil "John" =~ /a/
    end
    
    should "replace one occurrence with sub" do
      assert_equal "Jonas Johnson", "John Johnson".sub(/hn/, "nas")
    end

    should "replace all occurrences with gsub" do
      assert_equal "Jonas Jonasson", "John Johnson".gsub(/hn/, "nas")
    end
    
  end
  
  context "Type conversion" do
    
    should "convert to Fixnum, Bignum, or raise" do
      assert_equal 123, Integer(123)
      assert_equal 123, Integer("123")
      assert_equal 12345678901234567890, Integer("12345678901234567890")
      assert_raise(ArgumentError) do
        Integer("I am not an integer")
      end
    end
    
    should "convert to floats" do
      assert_equal 12.3, Float("12.3")
    end
    
  end
  
  context "Visibility" do
    
    should "be limited by block scope for local vars" do
      1.times { my_var = 1 }
      deny defined?(my_var)
    end
    
    should "not be limited for globals which are denoted by $" do
      1.times { $my_var = 1 }
      assert defined?($my_var)
      assert_equal 1, $my_var
    end
    
    should "not be limited by begin/end" do
      begin; my_var = 1; end
      assert defined?(my_var)
      assert_equal 1, my_var
    end
    
  end
  
  context "control structures" do
    
    should "include a for loop" do
      res = []
      for a in [1, 2, 3]
        res << a ** 2
      end
      assert_equal [1, 4, 9], res
    end
  
  end
  
  
end 
