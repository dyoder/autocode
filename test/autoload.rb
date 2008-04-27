require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "A module where autoload has been called" do
  
  before do
    module Thingy
      module Mabob
        extend Autocode
        autoload true, :type => Class, :directories => :test_lib
      end
    end
  end
  
  it "should autoload where files match" do  
    Thingy::Mabob::DooDad.should.respond_to :gizmo
  end
  
  it "should not autocreate those unmentioned and fileable" do
    lambda { Thingy::Mabob::MooCow }.should.raise NameError
  end
  
end