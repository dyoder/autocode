require 'rubygems'
require 'metaid'

# Extending a module with Autocreate allows you to specify autocreate rules for that module.
#
# Autocreate allows you to automatically created classes or modules based on a given exemplar at the time they are referenced.
#
# To use Autocreate, mix it via +extend+ into the class or module within which you want to autocreate referenced constants.
# 
# See the README for an example of how to use Autocreate.

module Autocreate
	
	def self.extended( mod ) #:nodoc:

		old = mod.method( :const_missing )
		mod.metaclass.class_eval do

			# The constant specified by key should be autocreated using the exemplar.
      # Any block given is added to the list of init_blocks, which will be executed
      # in the constant's module scope after it is cloned.
			def autocreate( key, exemplar, &block )
			  keys = case key
		    when Symbol then [key]
			  when Array  then key
			  end
			  
			  keys.each do |k|
			   	exemplars[k] = exemplar
          init_blocks[k] << block
			  end

				return self
			end
			
			def exemplars
			  @exemplars ||= Hash.new
			end
			
			def init_blocks
			 @init_blocks ||= Hash.new { |h,k| h[k] = [] }
			end
			
			
			define_method :const_missing do | cname | #:nodoc:
        cname = cname.to_sym
        exemplar = ( exemplars[cname] ? exemplars[cname] : exemplars[true]  )

				# if we found it, set the constant, run the blocks, and return it
				if exemplar 
					object = exemplar.clone
					( @reloadable ||= [] ) << cname; 
					const_set( cname, object )
          
          init_blocks[cname].each do |block|
            object.module_eval( &block) if block
          end
          
					return object
				else
					old.call(cname)
				end

			end

		end

	end

end