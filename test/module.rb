require File.join(File.dirname(__FILE__), 'helpers.rb')

describe "q_const_get method" do
  
  before do
    
    module W
      module X
        module Y
          module Z
          end
        end
      end
    end
    
  end
  
  it "can resolve a constant from a string of namespaced constants" do
    module W
      q_const_get("X::Y::Z").should == W::X::Y::Z
      q_const_get("X").should == W::X
    end
  end
  
end