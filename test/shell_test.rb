require_relative "test_init"

require 'shellwords'

class ShelltestTest < Test::Unit::TestCase
  
  context "Shellwords" do
    
    should "include a method for splitting a string according to shell parsing rules" do
      cmd = "ls -lh a 'b c' d"
      res = Shellwords::shellwords(cmd)
      assert_equal ['ls', '-lh', 'a', 'b c', 'd'], res
    end
    
  end
  
end