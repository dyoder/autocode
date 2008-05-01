require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autoload has been called" do
  
  before do
    module Thingy
      module Mabob
        extend Autocode; extend Unloadable;
        autoload_class true, Class, :directories => [File.join(File.dirname(__FILE__), "test_lib")]
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
    lambda { Thingy::Whatsit::Critter }.should.raise NameError
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
end