require 'rubygems'
require 'metaid'

# Reloadable simply makes it possible for a module's code to be reloaded. *Important*: Only code loaded via Autoload or Autocreate will be reloaded. Also, the module itself is not reloaded, only the modules and classes within it that were loaded via *Autocode*.
#
# To use Reloadable, simply extend a given module with Reloadable. This will add two methods to the module: reloadable and reload. These are described below.

module Reloadable
	
	def self.extended( mod ) #:nodoc:

		mod.metaclass.class_eval do
			
			# Returns the list of constants that would be reloaded upon a call to reload.
			def reloadable( *names ) 
				( @reloadable ||= [] ).concat(names)
				return self
			end
			
			# Reloads all the constants that were loaded via *Autocode*. Technically, all reload is doing is undefining them (by calling +remove_const+ on each in turn); they won't get reloaded until they are referenced.
			def reload
				( @reloadable ||=[] ).each { |name| remove_const( name ) }
				@reloadable = []; return self
			end
	
		end
		
	end
	
end