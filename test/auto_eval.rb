require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "auto_eval should" do

  before do
    A.reload if defined? A and A.respond_to? :reload
    module A
      include AutoCode
      auto_create_module :B
    end
    A.auto_eval :B do
      include AutoCode
      auto_create_class
    end
  end
  
  specify "allow you to run blocks after an object is first created" do
    A::B::C.class.should == Class
  end

end