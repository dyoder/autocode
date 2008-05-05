require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autocreate has been called" do
  before do
    module Thingy
      extend Autocode
      autocreate :Tom, Module.new do
        def self.peeps; true; end 
      end
      
      autocreate [:Dick, :Harry], Class.new do
        def self.peeps; false; end
      end
    end
  end
  
  after do
    Thingy.unload
  end

  it "should autocreate some constants" do
    Thingy::Tom.peeps.should == true
    Thingy::Dick.peeps.should == false
    Thingy::Harry.peeps.should == false
  end
  
  it "should not autocreate unregistered constants" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
  it "unless autocreate was called with key of true" do
    module Duffel
      extend Autocode
      autocreate true, Class.new do
        def self.universal; true; end
      end
    end
    
    Duffel::AnyThing.universal.should == true
    Duffel.unload
  end
  
  it "should be possible to include autocode" do
    module Waves
      include Autocode
      autocreate(:TestLib, Module.new) do
        include Autocode
        autocreate_class
        autoload_class
      end
    end
    Waves::TestLib::TheOneAndOnlyClass.help().should == "class help"
    Waves::TestLib::AnyThing.name.should == "Waves::TestLib::AnyThing"
    lambda { Waves::TestLib::TheOneAndOnlyModule }.should.raise TypeError
    Waves::TestLib::ThePretender.name.should == "Waves::TestLib::ThePretender"
    lambda { Waves::TestLib::ThePretender.help() }.should.raise NoMethodError
    Waves.unload
  end
  
end