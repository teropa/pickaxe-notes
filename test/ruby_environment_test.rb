require_relative "test_init"

class RubyEnvironmentTest < Test::Unit::TestCase
  
  context "ENV" do
  
    should "contain system environment variables" do
      assert_equal Dir.pwd, ENV['PWD']
    end
    
    should "also have variables set by Ruby itself" do
      assert ENV['RUBY_VERSION']
      assert ENV['RUBYOPT']
    end
    
  end

  context "RbConfig" do
  
    setup do
      @cfg = RbConfig::CONFIG
    end
    
    should "include info about the Ruby installation and the system it was built on" do
      assert_equal '1', @cfg['MAJOR']
      assert_equal '9', @cfg['MINOR']
      assert_equal '/bin/sh', @cfg['SHELL']
      assert_equal `uname -p`.chop, @cfg['build_cpu']
    end
    
  end

end