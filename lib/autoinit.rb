require 'rubygems'
require 'metaid'

module Autoinit
	
	def self.extended( mod ) #:nodoc:
		mod.metaclass.class_eval do

  		def autoinit( key, &block )
  		  
  		  match = key.to_s.match(/^(.*)::([\w\d_]+)$/)
  		  
  		  if match
  		    const = q_const_get(match[1])
    			const.module_eval do
    			  @init_blocks ||= Hash.new { |h,k| h[k] = [] }
    			  @init_blocks[match[2].to_sym] << block
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