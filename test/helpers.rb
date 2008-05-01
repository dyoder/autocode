%w{ rubygems bacon metaid }.each { |dep| require dep }
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

$:.unshift File.join(File.dirname(__FILE__) , "../lib")
require 'autocode'

module Unloadable
	def self.extended( mod )
		mod.metaclass.class_eval do		
      # Unloads all the constants that were loaded via *Autocode* and removes all autocode definitions.
			def unload
				( @reloadable ||=[] ).each { |name| remove_const( name ) }
        @reloadable = @exemplars = @init_blocks = @load_files = nil
				return self
			end
    end
  end
end
