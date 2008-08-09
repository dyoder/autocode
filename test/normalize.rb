require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "AutoCode should normalize const names" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :foo_bar
      auto_create_module :foo_bar_baz
      auto_create_module :weird_Casing
      auto_create_module :catch_22
      auto_create_module :front242
    end
    A.auto_eval( :foo_bar ) { self::D = true }
    A.auto_eval( :foo_bar_baz ) { self::D = true }
    A.auto_eval( :weird_Casing ) { self::D = true }
    A.auto_eval( :Catch22 ) { self::D = true }
    A.auto_eval( :Front242 ) { self::D = true }
  end
  
  specify "converting from snake-case to camel-case" do
    A::FooBar::D.should == true
    A::FooBarBaz::D.should == true
    A::WeirdCasing::D.should == true
    A::Catch22::D.should == true
    A::Front242::D.should == true
  end

end