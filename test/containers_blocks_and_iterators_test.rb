require_relative 'test_init'

class HasThreeThings
  
  def things(msg)
    yield "1 #{msg}"
    yield "2 #{msg}"
    yield "3 #{msg}"
  end
  
end

class ContainersBlocksAndIteratorsTest < Test::Unit::TestCase
  
  context "making arrays" do
    
    should "happen nicely for a bunch of words using %w" do
      assert_equal ["a", "b", "c"], %w[a b c]
    end
    
  end
  
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
  
  context "blocks and iterators" do
    
    should "be able to define block local variables" do
      a = :a
      [1, 2, 3].each do |i; a|
        a = i
        assert_equal i, a
      end
      assert_equal :a, a
    end
    
    should "be able to inject by just giving the accumulator method" do
      assert_equal 10, [1, 2, 3, 4].inject(:+)
    end
    
  end
  
  context "enumerators" do
    
    should "enumerate, and raise at the end" do
      e = [1, 2, 3].to_enum
      assert e.peek
      assert_equal 1, e.next
      assert_equal 2, e.next
      assert_equal 3, e.next
      assert_raise(StopIteration) { e.next }
    end
    
    should "return an enumerator from each, when invoked without a block" do
      assert [1, 2, 3].each.is_a?(Enumerator)
    end
    
    should "loop through an enumerator" do
      e = [1, 2, 3].to_enum
      r = []
      loop do
        r << e.next
      end
      assert_equal [1, 2, 3], r
    end
    
    should "loop until the shortest enumerator runs out" do
      e1 = [1, 2, 3].to_enum
      e2 = [4, 5, 6, 7].to_enum
      r = []
      loop do
        r << e1.next
        r << e2.next
      end
      assert_equal [1, 4, 2, 5, 3, 6], r
    end
    
    should "provide with_index" do
      e = "abcd".each_char
      idxs = []
      chrs = []
      e.with_index do |c, i|
        chrs << c
        idxs << i
      end
      assert_equal [0, 1, 2, 3], idxs
      assert_equal ["a", "b", "c", "d"], chrs
    end
    
    should "provide an enumerator that accesses a specific method" do
      e = HasThreeThings.new.to_enum(:things, "hello!")
      assert_equal "1 hello!", e.next
      assert_equal "2 hello!", e.next
      assert_equal "3 hello!", e.next
    end
  end
  
  context "Filters and generators" do
    
    setup do
      @fibo = Enumerator.new do |yielder|
        first = 0; second = 1
        loop do
          yielder.yield first
          first, second = second, first + second
        end
      end
    end
    
    should "be able to use enumerators as (potentially infinite) generators" do
      assert_equal 0, @fibo.first
      assert_equal [0, 1], @fibo.first(2)
      assert_equal [0, 1, 1], @fibo.first(3)
      assert_equal [0, 1, 1, 2], @fibo.first(4)
      assert_equal [0, 1, 1, 2, 3], @fibo.first(5)
      assert_equal [0, 1, 1, 2, 3, 5], @fibo.first(6)
      assert_equal 1000, @fibo.first(1000).size
    end
    
    def filter(enum, &block)
      Enumerator.new do |yielder|
        enum.each do |value|
          yielder.yield value if block.call(value)
        end
      end
    end
    
    should "be able to use enumerators as filters for other enumerators" do
      odd_fibo = filter(@fibo, &:odd?)
      assert_equal 1, odd_fibo.first
      assert_equal [1, 1], odd_fibo.first(2)
      assert_equal [1, 1, 3], odd_fibo.first(3)
      assert_equal [1, 1, 3, 5], odd_fibo.first(4)
    end
    
  end
  
  context "new lambda syntax" do
    
    should "create lambda from ->" do
      p = -> { "hello" }
      assert_equal "hello", p.call
    end
    
    should "give parameter to lambda" do
      p = -> a { "hello #{a}"}
      assert_equal "hello john", p.call("john")
    end
    
    should "give many parameters to lambda" do
      p = -> a,b { "hello #{a} and #{b}" }
      assert_equal "hello john and alan", p.call("john", "alan")
    end
    
    should "be able to give splat args to lambda" do
      p = -> *a { "hello #{a.join(', ')}" }
      assert_equal "hello john, alan, brian", p.call("john", "alan", "brian")
    end
    
    should "be able to give blocks to lambda" do
      p = -> &b { "hello #{b.call}" }
      assert_equal "hello john", p.call { "john" } 
    end
    
  end
  
end
