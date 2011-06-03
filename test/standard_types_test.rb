require_relative "test_init"

class StandardTypesTest < Test::Unit::TestCase

  context "number types" do
    
    should "support integers in different bases" do
      assert_equal 10, 0d10 # decimal
      assert_equal 14, 0xe  # hex
      assert_equal 10, 012  # octal
      assert_equal 3,  0b11 # binary
    end
    
    should "support underscores as separators" do
      assert_equal 1000000, 1_000_000
    end
    
    should "support exponents" do
      assert_equal 1000000, 1e6
      assert_equal 1100000, 1.1e6
    end
    
    should "support rationals" do
      assert_equal 1, 3 * Rational(1, 3)
      assert_equal Rational(1, 35), Rational(1, 5) * Rational(1, 7)
    end
    
    should "support complex numbers" do
      assert_equal 5, Complex(0, 5).imag
    end
    
  end
  
  context "mathn" do
    
    should "return rational fractions with mathn" do
      assert_equal 3, 22 / 7
      assert_not_equal Rational(22, 7), 22 / 7
      require 'mathn'
      assert_equal Rational(22, 7), 22 / 7
    end
    
  end
  
  context "strings" do
    
    should "be split limiting the max amount of tokens" do
      assert_equal ['a', 'b,c'], 'a,b,c'.split(',', 2)
    end
    
    should "have character replacement using tr" do
      assert_equal 'a-b-c', 'a_b_c'.tr('_', '-')
      assert_equal '12c', 'abc'.tr('ab', '12')
      assert_equal 'hippo', 'hello'.tr('el', 'ip')
      assert_equal 'bcde', 'abcd'.tr('a-y', 'b-z')
    end
    
  end
  
end
