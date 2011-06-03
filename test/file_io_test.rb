require_relative "test_init"

class FileIOTest < Test::Unit::TestCase
  
  context "constants" do
  
    should "have one for whether the os is case sensitive" do
      assert File::FNM_SYSCASE.zero?
    end
    
  end
  
end
