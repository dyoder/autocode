require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "thingy" do
  before do
    module Thingy
      extend Autocode
      autocreate(:Whatsit, Module.new) do
        extend Autocode
        autoload :Critter, :exemplar => Class.new, :directories => File.join(File.dirname(__FILE__), "test_lib")
      end
      
      autoinit(:Whatsit) do
        def self.in_scope; true; end
      end
          
      autoinit('Whatsit::Critter') do
        def self.outside_scope; true; end
        def instance; true; end
        # this definition overrides the one in the file
        def self.gizmo; 2; end
      end
      
      autocreate :Big, Module.new do
        extend Autocode
        autocreate :Bad, Module.new do
          extend Autocode
          autocreate :John, Class.new do
            def self.stinks?; true; end
          end
        end
      end
      
      autoinit('Big::Bad::John') do
        def self.stinks?; false; end
      end
      
    end
  end
  
  it "fdfdsf" do
    Thingy::Whatsit.in_scope.should.be.true
    Thingy::Whatsit::Critter.outside_scope.should.be.true
    Thingy::Whatsit::Critter.new.instance.should.be.true
    Thingy::Big::Bad::John.stinks?.should.be.false
  end
  
  it "should run autoinit blocks before the file loading" do
     Thingy::Whatsit::Critter.gizmo.should == 1
  end
  
  
end
