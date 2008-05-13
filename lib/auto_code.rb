module AutoCode
  
  # always make sure we have a camel-cased symbol
  def AutoCode.normalize( cname )  
    return cname unless cname.is_a? String
    cname.gsub(/(_)(\w)/) { $2.upcase }.gsub(/^([a-z])/) { $1.upcase }.intern
  end
  
  class Loader
    def initialize(options={}); @directories = options[:directories] ; end
    def call(cname)
      filename = Loader.snake_case( cname ) << '.rb'
      if @directories.nil?
        Kernel.load( filename )
      else
        path = @directories.map { |dir| File.join( dir.to_s, filename ) }.find { |path| File.exist?( path ) }
        Kernel.load( path ) rescue nil unless path.nil?
      end
    end
    def Loader.snake_case(cname)
      cname.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
  end
  
  class Creator
    def initialize( options, &block )
      @exemplar = (options[:exemplar]||Module.new).clone; @block = block
    end
    def call ; @exemplar.module_eval( &@block ) if @block ; @exemplar ; end
  end
  
  class Initializer
    def initialize( &block ) ;@block = block ; end
    def call( mod ) ; mod.module_eval( &@block ) ; end 
  end
      
  def self.extended( mod ) ; included(mod) ; end

  def self.included( mod )
    
    mod.instance_eval do

      # Initialize bookkeeping variables needed by AutoCode
      @initializers = Hash.new { |h,k| h[k] = [] }; @reloadable = []
      
      # Adds an auto_create block for the given key using the given exemplar if provided
      def auto_create( key = true, options = {}, &block )
        @initializers[ AutoCode.normalize( key ) ] << Creator.new( options, &block ); self
      end

      # Adds an auto_load block for the given key and directories
      def auto_load( key = true, options = {} )
        @initializers[ AutoCode.normalize( key ) ].unshift( Loader.new( options ) ); self
      end

      # Adds an arbitrary initializer block for the given key
      def auto_eval( key, &block )
        @initializers[ AutoCode.normalize( key ) ] << Initializer.new( &block ); self
      end

      # Convenience method for auto_create.
      def auto_create_class( key = true, superclass = Object, &block )
        auto_create( key,{ :exemplar => Class.new( superclass ) }, &block )
      end

      # Convenience method for auto_create.
      def auto_create_module( key = true, &block )
        auto_create( key,{ :exemplar => Module.new }, &block )
      end

      # Reloading stuff ...
      
      # Returns the list of constants that would be reloaded upon a call to reload.
      def reloadable( *names ) ; @reloadable + names ; end

      # Reloads all the constants that were loaded via auto_code. Technically, all reload
      # is doing is undefining them (by calling +remove_const+ on each in turn); they won't get
      # reloaded until they are referenced.
      def reload ; @reloadable.each { |name| remove_const( name ) } ; @reloadable = [] ; self; end

      # Unloads all the constants that were loaded and removes all auto* definitions.
      def unload ; reload ; @initializers = Hash.new { |h,k| h[k] = [] } ; self ; end

      private

      old = method( :const_missing )
      (class << self ; self ; end ).instance_eval do
        define_method :const_missing do | cname |
          ( @initializers[cname] + @initializers[true] ).each do |initializer|
            case initializer 
            when Loader then initializer.call( cname ) unless const_defined?(cname)
            when Creator then const_set( cname, initializer.call ) unless const_defined?(cname)
            else
              return old.call(cname) unless const_defined?( cname )
              initializer.call( const_get( cname ) ) if const_defined?( cname )
            end
          end
          return old.call(cname) unless const_defined?( cname )
          @reloadable << cname ; const_get( cname )
        end
      end
    end
  end
end