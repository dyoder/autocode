require 'rubygems'
require 'metaid'

# Autoload allows you to specify which modules or classes to automatically load when they are referenced. This is somewhat more sophisticated than the +autoinclude+ mechanism in the standard library. For one thing, you can cause code to be reloaded by using Reloadable in conjunction with Autoload. For another, you can provide a search path using the directories method, thereby allowing you to "autoinclude" entire directories in one fell swoop.
#
# To use Autoload, you must mix it into your module or class via extend. That will provide the autoload and directories methods for you, as described below.
#
# A typical use case for Autoload looks like this:
#
#   require 'autocode'
#   
#   module Models
#     extend Autoload; extend Reloadable
#     autoload true; directories :models
#   end

module Autoload
	
	def self.extended( mod ) #:nodoc:

		old = mod.method( :const_missing )
		
		mod.metaclass.class_eval do

			# Specifies that you want to autoload each of the constants referenced by keys. 
      # A key of true is basically a wild-card, meaning "load anything". 
			def autoload( *keys )
				( @autoload ||= [] ).concat(keys)
				return self
			end
			
			# Provide a list of directories from which a given constant might be loaded.
			def directories( *dirs )
				( @directories ||= ['.'] ).concat(dirs)
				return self
			end
			
			# Is a given constant being autoloaded?
			def autoload?( cname )

				cname = cname.to_s.gsub(/([a-z\d])([A-Z])/){ "#{$1}_#{$2.downcase}"}
				
				# is this name autoloadable?
				key = ( @autoload ||= [] ).find do |key| 
					key == true || ( key.to_s == cname )
				end
				
			end

			define_method :const_missing do | cname | #:nodoc:
				
				return old.call(cname) unless autoload?( cname )
				fname = ( cname.to_s.gsub(/([a-z\d])([A-Z])/){ "#{$1}_#{$2.downcase}"} + '.rb' ).downcase
				dir = ( @directories ||= ['.'] ).find do |dir|
					File.exist?( File.join(dir.to_s, fname) )
				end
				
				if ( dir && load( File.join(dir.to_s, fname) ) && c = const_get( cname ) )
					( @reloadable ||= [] ) << cname;
          
          if @autodef
            @autodef.select { |k,v| k.to_s == cname.to_s }.each do |k,bl|
              c.module_eval( &bl) if bl
            end
          end
          
					return c
				else 
					old.call( cname )
				end
				
			end
		
		end
		
	end

end
