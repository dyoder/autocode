require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "thingy" do
  before do
    module Thingy
      extend Autocreate; extend Reloadable
      module Mabob
        extend Autoload
        autoload true, :type => Class, :directories => :test_lib
      end
    end
  end
  
  after do
    Thingy.class_eval do
      # remove_const :Mabob
    end
  end

  it "should autocreate some constants" do
    module Thingy
      autocreate :Tom, Module.new do
        def self.peeps; true; end 
      end
      
      autocreate [:Dick, :Harry], Class.new do
        def self.peeps; false; end
      end
    end
    
    Thingy::Tom.peeps.should == true
    Thingy::Dick.peeps.should == false
    Thingy::Harry.peeps.should == false
  end
  
  it "should autoload where files match" do  
    Thingy::Mabob::DooDad.should.respond_to :gizmo
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
  it "should run the autodef blocks upon create and load" do
    module Thingy
      autocreate(:Whatsit, Module.new) do
        extend Autoload
        autoload :Critter, :type => Class, :directories => :test_lib
      end
      
      extend Autoinit
      autoinit(:Whatsit) do
        def self.in_scope; true; end
      end
          
      autoinit('Whatsit::Critter') do
        def self.outside_scope; true; end
        def instance; true; end
        def self.gizmo; 2; end
      end
      
      autocreate :Big, Module.new do
        extend Autocreate
        autocreate :Bad, Module.new do
          extend Autocreate
          autocreate :John, Class.new do
            def self.stinks?; true; end
          end
        end
      end
      
      autoinit('Big::Bad::John') do
        def self.stinks?; false; end
      end
      
    end
    
    Thingy::Whatsit.in_scope.should.be.true
    Thingy::Whatsit::Critter.outside_scope.should.be.true
    Thingy::Whatsit::Critter.new.instance
    Thingy::Big::Bad::John.stinks?.should.be.false
  end
  
  it "should run autodef blocks after the file loading" do
     Thingy::Whatsit::Critter.gizmo.should == 2
  end
  
  
end