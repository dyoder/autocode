module Autocode

  def self.extended( mod )
    included(mod)
  end

  def self.included( mod )

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

      def autocreate_class( key = true, superclass = Class, &block )
        autocreate( key, Class.new( superclass ), &block )
      end

      def autocreate_module( key = true, &block )
        autocreate( key, Module.new, &block )
      end

      def autoinit( key, &block )
        if match = key.to_s.match(/^([\w\d_]+)::(.*)$/)
          const, rest = match[1,2]
          autoinit(const.to_sym) do
            autoinit(rest, &block)
          end
        else
          @init_blocks ||= Hash.new { |h,k| h[k] = [] }
          @init_blocks[key.to_sym] << block
        end

        return self
      end

      def autoload(key = true, options = {})
        snake_case = lambda {|name| name.gsub(/([a-z\d])([A-Z])/){"#{$1}_#{$2}"}.tr("-", "_").downcase }
        # look for load_files in either a specified directory, or in the directory
        # with the snakecase name of the enclosing module
        directories = [options[:directories] || snake_case.call(self.name.match( /^.*::([\w\d_]+)$/)[1])].flatten
        # create a lambda that looks for a file to load
        file_finder = lambda do |cname|
          filename = snake_case.call(cname.to_s << ".rb")
          path = directories.map { |dir| File.join(dir.to_s, filename) }.find { |path| File.exist?( path ) }
        end
        # if no exemplar is given, assume Module.new
        @load_files ||= Hash.new
        @load_files[key] = [file_finder, options[:exemplar] || Module.new]
        return self
      end

      def autoload_class(key = true, superclass = Class, options = {})
        options[:exemplar] = Class.new(superclass)
        autoload key, options
      end

      def autoload_module(key = true, options = {})
        options[:exemplar] = Module.new
        autoload key, options
      end

      # Returns the list of constants that would be reloaded upon a call to reload.
      def reloadable( *names )
        ( @reloadable ||= [] ).concat(names)
        return self
      end

      # Reloads all the constants that were loaded via autocode. Technically, all reload
      # is doing is undefining them (by calling +remove_const+ on each in turn); they won't get
      # reloaded until they are referenced.
      def reload
        @reloadable.each { |name| remove_const( name ) } if @reloadable
        @reloadable = nil
        return self
      end

      # Unloads all the constants that were loaded and removes all auto* definitions.
      def unload
        reload
        @exemplars = @init_blocks = @load_files = nil
        return self
      end

      private

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
    end
  end
end