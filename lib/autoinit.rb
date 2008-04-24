require 'rubygems'
require 'metaid'

module Autoinit
	
	def self.extended( mod ) #:nodoc:
		mod.metaclass.class_eval do

  		def autodef( key, &block )
  		  match = key.to_s.match(/^(.*)::([\w\d_]+)$/)
  		  
  		  if match
  		    const = const_get(match[1])
    			const.module_eval do
    			 init_blocks << [ match[2], block ]  
    			end
  			else
    			init_blocks << [ key, block ]
  			end
  			return self
  		end
  		
  		def init_blocks
			 @init_blocks ||= Hash.new { |h,k| h[k] = [] }
			end

		end

	end

end