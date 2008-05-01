require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autocreate has been called" do
  before do
    module Thingy
      extend Autocode; extend Unloadable;
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
      extend Autocode; extend Unloadable;
      autocreate true, Class.new do
        def self.universal; true; end
      end
    end
    
    Duffel::AnyThing.universal.should == true
    Duffel.unload
  end
  
end