require 'reloadable'

module Autocode
	
	def self.extended( mod ) #:nodoc:

		old = mod.method( :const_missing )
		mod.metaclass.class_eval do
		  
		  def autocreate( key, exemplar, &block )
			  keys = case key
		    when true, Symbol then [key]
			  when Array then key
			  end
			  
			  @exemplars ||= Hash.new
			  @init_blocks ||= Hash.new { |h,k| h[k] = [] }
			  keys.each do |k|
			   	@exemplars[k] = exemplar
          @init_blocks[k] << block
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
    			@init_blocks[key] << block
  			end
  			return self
  		end
		  
		  def autoload( key, options )
		    # look for load_files in either a specified directory, or in the directory
		    # with the snakecase name of the enclosing module
		    directories = [options[:directories] || default_directory(self.name)].flatten
        # create a lambda that looks for a file to load
        file_finder = lambda do |cname|
          filename = default_file_name(cname)
          dirname = directories.find do |dir|
  			    File.exist?(File.join(dir.to_s, filename))
  			  end
  			  dirname ? File.join(dirname.to_s, filename) : nil
        end
        # if no exemplar is given, assume Module.new
			  @load_files ||= Hash.new
        @load_files[key] = [file_finder, options[:exemplar]]
				return self
		  end
		  
		  def autoload_class(key, superclass=nil, options={})
		    options[:exemplar] = Class.new(superclass)
		    autoload key, options
		  end
		  
		  def autoload_module(key, options={})
		    options[:exemplar] = Module.new
		    autoload key, options
		  end
		  
		  
		  define_method :const_missing do | cname | #:nodoc:
        cname = cname.to_sym
        @exemplars ||= Hash.new
        @init_blocks ||= Hash.new { |h,k| h[k] = [] }
			  @load_files ||= Hash.new
        exemplar = @exemplars[cname] || @exemplars[true]
        blocks = @init_blocks[cname]
        blocks = @init_blocks[true] + blocks if @exemplars[cname].nil? && @init_blocks[true]
        load_file_finder, load_class = @load_files[cname] || @load_files[true]
        
			  if load_file_finder && filename = load_file_finder.call(cname)
			    object = load_class.clone
				elsif exemplar 
					object = exemplar.clone
		    else
		      return old.call(cname)
	      end
			  			    
				(@reloadable ||= []) << cname; 
				const_set( cname, object )
         
        blocks.each do |block|
          object.module_eval( &block) if block
        end
        load(filename) if filename
				return object
			end
			
			def default_file_name(cname)
			 ( cname.to_s.gsub(/([a-z\d])([A-Z\d])/){ "#{$1}_#{$2}"} << ".rb" ).downcase
			end
			
			def default_directory(module_name)
			  m = self.name.match( /^.*::([\w\d_]+)$/)
			  m[1].snake_case
			end
		  
	  end
  end
end