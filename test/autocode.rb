require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "thingy" do
  
  before do
    
    module Thingy
      extend Autocreate; extend Autoload; extend Reloadable

      autocreate :Mabob, Module.new do 
        extend Autoload
        autoload true
        directories :test_lib
      end
    end

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
    # 
    #   autodef('Mabob::Doodad') do
    #     def self.gizmo; 2; end
    #   end
    # end
    
  end
  
  it "should autocreate some constants" do
    lambda do
      Thingy::Mabob
    end.should.not.raise
  end
  
  it "should autoload where files match" do
    lambda do
      Thingy::Mabob::Doodad.should.respond_to :gizmo
    end.should.not.raise
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::MooCow }.should.raise NameError
  end
  
  # it "should run the autodef blocks upon create and load" do
  #   Thingy::Mabob.in_scope.should == true
  #   Thingy::Mabob::Doodad.outside_scope.should == true
  #   Thingy::Mabob::Doodad.new.instance
  # end
  # 
  # it "should run autodef blocks after the file loading" do
  #    Thingy::Mabob::Doodad.gizmo.should == 2
  # end
  
  
end