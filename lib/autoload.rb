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
		mod.module_eval do
		  extend Autocreate
	  end
		
		mod.metaclass.class_eval do

			# Specifies that you want to autoload each of the constants referenced by keys. 
      # A key of true is basically a wild-card, meaning "load anything". 
			def autoload( key, options )
        # @autoload ||= {}
        # if key.respond_to? :inject
        #           key.inject(@autoload) { |hash, key| hash[key] = true; hash }
        # else
        #   @autoload[key] = true
        #         end
        # directories(options[:directories])
        autocreate(key, (options[:type] || Module).new ) do |cname|
          autoload_file(Autoload.default_file_name(cname, options[:directories]))
        end
				return self
			end
			
			# Provide a list of directories from which a given constant might be loaded.
			def directories( *dirs )
				( @directories ||= ['.'] ).concat(dirs)
				return self
			end
			
			def Autoload.default_file_name(cname)
			 ( cname.to_s.gsub(/([a-z\d])([A-Z\d])/){ "#{$1}_#{$2}"} << ".rb" ).downcase
			end
			
			# Is a given constant being autoloaded?
			def autoload?( cname )
			  # A value of false for a specific key overrides the more general key of true.
			  # This is useful in preventing infinite recursion.
			  return false if @autoload[false]
				@autoload[cname] || @autoload[true]
			end
			
			def autoload_file(filename, dirs)
			  dirname = (dirs ||= ['.']).find do |dir|
			    File.exist?(File.join(dir.to_s, filename))
			  end
			  dirname && (file = File.join(dirname.to_s, filename)) && load(file)
			end

      # define_method :const_missing do | cname | #:nodoc:
      #   return old.call(cname) unless autoload?( cname )
      #   
      #   fname = @autoload[cname].is_a?(String) ? @autoload[cname] : Autoload.default_file_name(cname) 
      #   
      #   # set autoloading for this cname to false, in case a file of the right name 
      #   # exists, but does not define the appropriate constant.  If the constant is found,
      #   # set autoloading for the cname back to whatever it was. 
      #   tmp, @autoload[cname] = @autoload[cname], false
      #   if autoload_file(fname, @directories ||= ['.']) && c = const_get( cname )  # source of infinite loop
      #     @autoload[cname] = tmp
      #     ( @reloadable ||= [] ) << cname;
      #           
      #           if @init_blocks
      #             @init_blocks[cname].each do |block|
      #               c.module_eval( &block) if block
      #             end
      #           end
      #           
      #     return c
      #   else 
      #     old.call( cname )
      #   end
      #   
      # end
		
		end
		
	end

end
