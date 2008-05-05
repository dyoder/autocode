require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autoload has been called" do
  
  before do
    module Thingy
      module Mabob
        extend Autocode
        autoload_class :DooDad, Class, :directories => [File.join(File.dirname(__FILE__), "test_lib")]
        autoload_module :Humbug, :directories => [File.join(File.dirname(__FILE__), "test_lib")]
      end
    end
  end
  
  after do
    Thingy::Mabob.unload
  end

  it "should autoload where files match" do  
    Thingy::Mabob::DooDad.should.respond_to :gizmo
    Thingy::Mabob::Humbug.should.respond_to :full_of_it?
  end
  
  it "should not autoload where it matches a file but is out of scope" do
    lambda { Thingy::Mabob::Answer42ItIs }.should.raise NameError
    lambda { Thingy::Whatsit::Critter }.should.raise NameError
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
  it "should autoload using super class" do
    module Waves
      module TestLib
        extend Autocode
        autoload_class true, Thingy::Mabob::DooDad
      end
    end
    Waves::TestLib::TheClass42Gang.party?.should == true
    Waves::TestLib::TheClass42Gang.gizmo.should == 1
    Waves::TestLib.unload
  end

  it "should autoload using defaults" do
    module Waves
      module TestLib
        extend Autocode
        autoload
      end
    end    
    Waves::TestLib::TheOneAndOnlyModule.help().should == "module help"
    lambda { Waves::TestLib::TheOneAndOnlyClass }.should.raise TypeError
    Waves::TestLib::ThePretender.name.should == "Waves::TestLib::ThePretender"
    lambda { Waves::TestLib::ThePretender.help() }.should.raise NoMethodError
    Waves::TestLib.unload
  end
  
  it "should autoload class using defaults" do
    module Waves
      module TestLib
        extend Autocode
        autoload_class
      end
    end
    Waves::TestLib::TheOneAndOnlyClass.help().should == "class help"
    lambda { Waves::TestLib::TheOneAndOnlyModule }.should.raise TypeError
    Waves::TestLib::ThePretender.name.should == "Waves::TestLib::ThePretender"
    lambda { Waves::TestLib::ThePretender.help() }.should.raise NoMethodError
    Waves::TestLib.unload
  end

  it "should autoload module using defaults" do
    module Waves
      module TestLib
        extend Autocode
        autoload_module
      end
    end
    Waves::TestLib::TheOneAndOnlyModule.help().should == "module help"
    lambda { Waves::TestLib::TheOneAndOnlyClass }.should.raise TypeError
    Waves::TestLib::ThePretender.name.should == "Waves::TestLib::ThePretender"
    lambda { Waves::TestLib::ThePretender.help() }.should.raise NoMethodError
    Waves::TestLib.unload
  end
end