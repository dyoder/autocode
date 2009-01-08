require "#{File.dirname(__FILE__)}/helpers"

describe "auto_eval" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :B
    end
    A.auto_eval :B do
      include AutoCode
      auto_create_class
    end
    A.auto_eval :B do
      include AutoCode
      auto_eval :C do
        self::D = true
      end
    end
  end
  
  specify "allows you to run blocks after an object is first created" do
    A::B::C.class.should == Class
  end
  
  specify "allows you to define nested auto_eval declarations" do
    A::B::C::D.should == true
  end
  

end