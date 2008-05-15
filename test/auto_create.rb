require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "auto_create should" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :B do
        include AutoCode
        auto_create_class
      end
    end
  end
  
  specify "allow you create and initialize a given const name" do
    A::B.class.should == Module
  end
  
  specify "allow you create and initialize const using a wildcard" do
    A::B::C.class.should === Class
  end
  
  specify "should raise a NameError if a const doesn't match" do
    lambda{ A::C }.should.raise NameError
  end
  
end