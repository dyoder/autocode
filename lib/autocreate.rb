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

			# Specifies that the constant specified by key should be autocreated using the exemplar. If a block is given, the block is further used to initialize the block once it has been cloned.
			def autocreate( key, exemplar, &block )
				( @autocreate ||= [] ) << [ key, exemplar, block ]
				return self
			end
			
			define_method :const_missing do | cname | #:nodoc:

				# first, find an applicable exemplar	
				key, exemplar, block = ( @autocreate ||= [] ).find do |k,v|
					case k
						when true then true
						when String, Symbol then k.to_s == cname.to_s 
						when Array then k.find { |k| k.to_s == cname.to_s }
						else false
					end
				end

				# if we found it, set the const and return it
				if key 
					object = exemplar.clone
					( @reloadable ||= [] ) << cname; 
					const_set( cname, object )
					object.instance_eval( &block ) if block
          
          # if @autodef
            @autodef.select { |k,v| k.to_s == cname.to_s }.each do |k,bl|
              object.module_eval( &bl) if bl
            end
          # end
          
					return object
				else
					old.call(cname)
				end

			end

		end

	end

end