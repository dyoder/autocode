require 'rubygems'
require 'metaid'

module Autodef
	
	def self.extended( mod ) #:nodoc:
		mod.metaclass.class_eval do

  		# Specifies that the constant specified by key should be autocreated using the exemplar. If a block is given, the block is further used to initialize the block once it has been cloned.
  		def autodef( key, &block )
  		  match = key.to_s.match(/^(.*)::([\w\d_]+)$/)
  		  
  		  if match
  		    const = const_get(match[1])
    			const.module_eval do
    			 ( @autodef ||= [] ) << [ match[2], block ]  
    			end
  			else
    			( @autodef ||= [] ) << [ key, block ]
  			end
  			return self
  		end

		end

	end

end