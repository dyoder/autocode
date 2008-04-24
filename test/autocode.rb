require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "thingy" do
  

    # 
    #   autodef('Mabob::Doodad') do
    #     def self.gizmo; 2; end
    #   end
    # end

  it "should autocreate some constants" do
    module Thingy
      extend Autocreate
      autocreate :Mabob, Module.new do
        def self.works; true; end 
      end
      
      autocreate [:Tom, :Dick, :Harry], Class.new do
        def self.peeps; true; end
      end
    end
    
    Thingy::Mabob.works.should == true
    Thingy::Tom.peeps.should == true
    Thingy::Dick.peeps.should == true
    Thingy::Harry.peeps.should == true
  end
  
  it "should autoload where files match" do
    module Thingy
      module Whatsit
        extend Autoload
        autoload true
        directories :test_lib
      end
    end
    
    lambda { Thingy::Whatsit::Doodad.should.respond_to :gizmo }.should.not.raise
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::MooCow }.should.raise NameError
  end
  
  # it "should run the autodef blocks upon create and load" do
    # Thingy.module_eval do
    #   extend Autodef
    #   autodef(:Mabob) do
    #     def self.in_scope; true; end
    #   end
    # 
    #   autodef('Mabob::Doodad') do
    #     def self.outside_scope; true; end
    #     def instance; true; end
    #   end
  #   Thingy::Mabob.in_scope.should == true
  #   Thingy::Mabob::Doodad.outside_scope.should == true
  #   Thingy::Mabob::Doodad.new.instance
  # end
  # 
  # it "should run autodef blocks after the file loading" do
  #    Thingy::Mabob::Doodad.gizmo.should == 2
  # end
  
  
end