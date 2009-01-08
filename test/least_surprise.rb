require "#{File.dirname(__FILE__)}/helpers"

describe "An auto_created module" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      module Foo; end
      include AutoCode
      auto_create_class :B do
        def kobold
          "koboldy"
        end
      end
    end
  end
  
  it "automatically includes AutoCode" do
    A::B.included_modules.should.include AutoCode
  end
  
  it "can be initialized by later auto_eval declarations" do
    A.auto_eval(:B) { def smurf; "smurfy" ; end }
    A::B.new.kobold.should == "koboldy"
    A::B.new.smurf.should == "smurfy"
  end
  
  it "can be referenced in auto_* declarations without getting born" do
    A.auto_create_class :C, :B
    A.const_defined?(:B).should == false
    A::C.new.kobold.should == "koboldy"
  end
  
end

describe "auto_eval" do
  
  it "does a module_eval for constants that are already defined" do
    A.auto_eval :Foo do
      def self.yell; "Brick!" ; end
    end
    A::Foo.yell.should == "Brick!"
  end
  
end


from_waves = lambda do
  app.auto_create_module( :Views ) do
    include AutoCode
    auto_create_class :Default, Waves::Views::Base
    auto_load :Default, :directories => [ :views ]
    auto_create_class true, :Default
    auto_load true, :directories => [ :views ]
  end
  app.auto_eval :Views do
    auto_eval :Default do
      include ViewMethods
    end
  end
end