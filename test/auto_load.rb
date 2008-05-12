require File.join(File.dirname(__FILE__), 'helpers.rb')
require 'extensions/io'


describe "auto_load should" do

  before do
    A.reload if defined? A and A.respond_to? :reload
    FileUtils.mkdir('tmp')
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
      auto_create_class :B
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
  
  specify "always take precedence over auto_create" do
    A::B.class.should == Module
  end

end