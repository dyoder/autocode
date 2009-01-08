require "#{File.dirname(__FILE__)}/helpers"
require 'extensions/io'


describe "auto_load" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    FileUtils.mkdir('tmp') rescue nil
    @path = File.join( 'tmp', 'b.rb' )
    content =<<-EOF
      module A
        module B
        end
      end
    EOF
    File.write( @path, content )
    module A
      include AutoCode
      auto_create_class :B
      auto_load :B, :directories => ['tmp']
    end
    
  end
  
  after do
    FileUtils.rm( File.join( @path ) )
    FileUtils.rmdir( 'tmp' )
  end
  
  specify "allows you to load a file to define a const" do
    A::B.class.should == Module
  end
  
  specify "should implement LIFO semantics" do
    A::B.class.should == Module
  end

  specify "raises a NameError if a const doesn't match" do
    lambda{ A::C }.should.raise NameError
  end

end