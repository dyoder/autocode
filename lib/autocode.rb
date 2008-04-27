require 'autocreate'
require 'autoload'
require 'autoinit'
require 'reloadable'

module Autocode
	
	def self.extended( mod ) #:nodoc:

		old = mod.method( :const_missing )
		mod.metaclass.class_eval do
		  def autoload( key, options )
		    directories = [options[:directories]].flatten
        # create a lambda that looks for a file to load
        file_finder = lambda do |cname|
          filename = default_file_name(cname)
          dirname = directories.find do |dir|
  			    File.exist?(File.join(dir.to_s, filename))
  			  end
  			  dirname ? File.join(dirname.to_s, filename) : nil
        end
        load_files[key] = [file_finder, options[:type]]
				return self
		  end
		  
		  
		  
		  
		  define_method :const_missing do | cname | #:nodoc:
        cname = cname.to_sym
        exemplar = exemplars[cname] || exemplars[true]
        load_file, load_class = load_files[cname] || load_files[true]
        

				# if we found it, set the constant, run the blocks, and return it
				if exemplar 
					object = exemplar.clone
			  elsif filename = load_file.call(cname)
			    object = load_class.clone
		    else
		      return old.call(cname)
	      end
			  			    
				reloadable << cname; 
				const_set( cname, object )
         
        init_blocks[cname].each do |block|
          object.module_eval( &block) if block
        end
        load(filename) if filename
				return object
			end
			
			def exemplars
			  @exemplars ||= Hash.new
			end
			
			def init_blocks
			 @init_blocks ||= Hash.new { |h,k| h[k] = [] }
			end
		  
		  def load_files
			  @load_files ||= Hash.new
			end
			
			def default_file_name(cname)
			 ( cname.to_s.gsub(/([a-z\d])([A-Z\d])/){ "#{$1}_#{$2}"} << ".rb" ).downcase
			end
			
			def reloadable
			 @reloadable ||= []
			end
		  
		  
		  
	  end
  end
end