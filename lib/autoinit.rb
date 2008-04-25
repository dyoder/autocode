require 'rubygems'
require 'metaid'

module Autoinit
	
	def self.extended( mod ) #:nodoc:
		mod.metaclass.class_eval do

  		def autoinit( key, &block )
  		  
  		  # See whether we're dealing with a namespaced constant,
  		  # The match groupings for,  e.g. "X::Y::Z", would be
  		  # ["X::Y", "Z"]
  		  match = key.to_s.match(/^(.*)::([\w\d_]+)$/)
  		  
  		  if match
  		    namespace, cname = match[1,2]
  		    const = module_eval(namespace)
    			const.module_eval do
    			  @init_blocks ||= Hash.new { |h,k| h[k] = [] }
    			  @init_blocks[cname.to_sym] << block
    			end
  			else
  			  @init_blocks ||= Hash.new { |h,k| h[k] = [] }
    			@init_blocks[key] << block
  			end
  			return self
  		end
  		

		end

	end

end