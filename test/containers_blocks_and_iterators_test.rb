require_relative 'test_init'

class ContainersBlocksAndIteratorsTest < Test::Unit::TestCase
  
  context "array manipulation by giving index and length" do
    
    setup do
      @a = [1, 2, 3, 4]
    end
    
    should "insert scalar to array when given two indexes" do
      @a[1, 0] = 5
      assert_equal [1, 5, 2, 3, 4], @a
    end
    
    should "insert and remove when given two indexes and the second is nonzero" do
      @a[1, 2] = 5
      assert_equal [1, 5, 4], @a
    end
    
    should "splice array to array when given two indexes and an array" do
      @a[1, 0] = [5, 6]
      assert_equal [1, 5, 6, 2, 3, 4], @a
    end
    
    should "be able to give negative starting index in the two index form" do
      @a[-2, 0] = 5
      assert_equal [1, 2, 5, 3, 4], @a
    end
    
  end
  
  context "arrays as stacks and fifos" do
    
    should "be able to treat an array as a stack" do
      a = []
      a.push 1
      a.push 2
      a.push 3
      assert_equal 3, a.pop
      assert_equal 2, a.pop
      assert_equal 1, a.pop
      assert a.empty?
    end
    
    should "be able to treat an array as a FIFO queue" do
      a = []
      a.push 1
      a.push 2
      a.push 3
      assert_equal 1, a.shift
      assert_equal 2, a.shift
      assert_equal 3, a.shift
      assert a.empty?
    end
    
  end
  
  context "aspects of Hash" do
    
    should "retain insertion order since 1.9" do
      h = {d: 1, b: 2, c: 3, a: 5, e: 4}
      assert_equal [:d, :b, :c, :a, :e], h.keys
      assert_equal [1, 2, 3, 5, 4], h.values
    end
    
  end
  
    
end
