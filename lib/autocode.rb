# require 'autocreate'
# require 'autoload'
# require 'autoinit'
require 'reloadable'

module Autocode
	
	def self.extended( mod ) #:nodoc:

		old = mod.method( :const_missing )
		mod.metaclass.class_eval do
		  
		  def autocreate( key, exemplar, &block )
			  keys = case key
		    when true then [true]
		    when Symbol then [key]
			  when Array  then key
			  end
			  
			  keys.each do |k|
			   	exemplars[k] = exemplar
          init_blocks[k] << block
			  end

				return self
			end
			
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
        blocks = init_blocks[cname]
        blocks = init_blocks[true] + blocks if exemplars[cname].nil? && init_blocks[true]
        load_file, load_class = load_files[cname] || load_files[true]
        

				# if we found it, set the constant, run the blocks, and return it
				if exemplar 
					object = exemplar.clone
			  elsif filename = load_file.call(cname)
			    object = load_class.new.clone
		    else
		      return old.call(cname)
	      end
			  			    
				reloadable << cname; 
				const_set( cname, object )
         
        blocks.each do |block|
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