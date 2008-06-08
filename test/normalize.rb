require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "AutoCode should normalize const names" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :foo_bar
    end
    A.auto_eval :foo_bar do
      self::D = true
    end
  end
  
  specify "converting from snake-case to camel-case" do
    A::FooBar::D.should == true
  end

end