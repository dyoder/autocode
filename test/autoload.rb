require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autoload has been called" do
  
  before do
    module Thingy
      module Mabob
        extend Autocode
        autoload_class true, Class, :directories => [File.join(File.dirname(__FILE__), "test_lib")]
        autoload_module :Humbug, :directories => [File.join(File.dirname(__FILE__), "test_lib")]
      end
    end
    module Waves
      module TestLib
        extend Autocode
        autoload true, :exemplar => Module.new
      end
    end
    module Whatever
      module TestLib
        extend Autocode
        autoload
      end
    end
  end
  
  after do
    Thingy::Mabob.unload
    Waves::TestLib.unload
    Whatever::TestLib.unload
  end

  it "should autoload where files match" do  
    Thingy::Mabob::DooDad.should.respond_to :gizmo
    Thingy::Mabob::Humbug.should.respond_to :full_of_it?
  end
  
  it "should not autoload where it matches a file but is out of scope" do
    lambda { Thingy::Whatsit::Critter }.should.raise NameError
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
  it "should autoload using default directories" do
    Waves::TestLib::TheHelperModule.should.respond_to :help
  end

  it "should allow default options" do
    Whatever::TestLib::TheOneAndOnly.should.respond_to :help
  end
  
end