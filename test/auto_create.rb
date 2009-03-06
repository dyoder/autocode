require "#{File.dirname(__FILE__)}/helpers"

describe "auto_create" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    module A
      include AutoCode
      auto_create_module :B do
        
        def self.smurf; "blue" ; end
        
        auto_create_module true do
          def self.pixie; "brown" ; end
        end
        
      end
    end
  end
  
  it "allows you create and initialize a given const name" do
    A::B.smurf.should == "blue"
  end
  
  it "allows you create and initialize const using a wildcard" do
    A::B::C.pixie.should == "brown"
  end
  
  it "allows you to refer to auto-constructed constants using symbols" do
    module K
      include AutoCode
      auto_create_class true, :C
      auto_create_class :C
    end
    K::C
    K::D.superclass.should == K::C
  end
  
  it "lets you use Module.name in the init block" do
    module L
      include AutoCode
      auto_create_class true do
        auto_create_class self.name.split("::").last.upcase.reverse do
          def self.foo; "bar" ; end
        end
      end
    end
    L::WONK::KNOW.foo.should == "bar"
  end
  
  it "raises a NameError if a const doesn't match" do
    lambda{ A::C }.should.raise NameError
  end
  
  it "can take a Regexp as a key" do
    module M
      include AutoCode
      auto_create_module(/V\d+/) do
        def self.thing
          name.split("::").last.reverse
        end
      end
    end
    M::V2.thing.should == "2V"
    M::V3.thing.should == "3V"
  end
  
end