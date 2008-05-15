require File.join(File.dirname(__FILE__), 'helpers.rb')
require 'extensions/io'


describe "auto_load should" do

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
  
  specify "allow you to load a file to define a const" do
    A::B.class.should == Module
  end
  
  specify "should raise a NameError if a const doesn't match" do
    lambda{ A::C }.should.raise NameError
  end
    
  specify "snake case the constant name which is used to map a constant to a filename" do
    AutoCode.snake_case(:Post).should == "post"
    AutoCode.snake_case(:GitHub).should == "git_hub"
    AutoCode.snake_case(:GITRepository).should == "git_repository"
    AutoCode.snake_case(:Git42Repository).should == "git42_repository"
    AutoCode.snake_case(:GIT42Repository).should == "git42_repository"
  end

end