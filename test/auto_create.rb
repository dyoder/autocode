require "#{File.dirname(__FILE__)}/helpers"

describe "auto_create" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :B do
        auto_create_class :C
        auto_create_class true, :C
      end
    end
  end
  
  specify "allows you create and initialize a given const name" do
    A::B.class.should == Module
  end
  
  specify "allows you create and initialize const using a wildcard" do
    A::B::C.class.should === Class
    A::B::D.superclass.should == A::B::C
  end
  
  specify "raises a NameError if a const doesn't match" do
    lambda{ A::C }.should.raise NameError
  end
  
end