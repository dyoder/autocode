module AutoCode
  
  # always make sure we have a camel-cased symbol
  def AutoCode.normalize( cname )  
    return cname unless cname.is_a? String
    cname.gsub(/(_)(\w)/) { $2.upcase }.gsub(/^([a-z])/) { $1.upcase }.intern
  end
  
  def AutoCode.snake_case( cname )
    cname.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
  end
        
  def self.extended( mod ) ; included( mod ) ; end

  def self.included( mod )
    
    mod.instance_eval do

      # First make sure we haven't already done this once
      return unless @autocode.nil?
      
      # Initialize bookkeeping variables needed by AutoCode
      @autocode = { 
        :constructors => Hash.new { |h,k| h[k] = [] },
        :initializers => Hash.new { |h,k| h[k] = [] },
        :loaded => []
      }
      
      # Adds an auto_create block for the given key using the given exemplar if provided
      def auto_create( key = true, options = {}, &block )
        @autocode[:constructors][ AutoCode.normalize( key ) ] << lambda do | cname |
          exemplar = ( options[:exemplar] || Module.new ).clone
          exemplar.module_eval( &block ) if block
          const_set( cname, exemplar )
        end
      end

      # Adds an auto_load block for the given key and directories
      def auto_load( key = true, options = {} )
        @autocode[:constructors][ AutoCode.normalize( key ) ] << lambda do | cname |
          filename = AutoCode.snake_case( cname ) << '.rb'
          if options[:directories].nil?
            Kernel.load( filename )
          else
            path = options[:directories].
              map { |dir| File.join( dir.to_s, filename ) }.
              find { |path| File.exist?( path ) }
            Kernel.load( path ) rescue nil unless path.nil?
          end
        end
      end

      # Adds an arbitrary initializer block for the given key
      def auto_eval( key, &block )
        @autocode[:initializers][ AutoCode.normalize( key ) ] << lambda do | cname |
          const_get( cname ).module_eval( &block )
        end
      end

      # Convenience method for auto_create.
      def auto_create_class( key = true, superclass = Object, &block )
        auto_create( key,{ :exemplar => Class.new( superclass ) }, &block )
      end

      # Convenience method for auto_create.
      def auto_create_module( key = true, &block )
        auto_create( key,{ :exemplar => Module.new }, &block )
      end

      # Returns the list of constants that would be reloaded upon a call to reload.
      def reloadable ; @autocode[:loaded] ; end

      # Reloads (via #remove_const) all the constants that were loaded via auto_code.
      def reload ; @autocode[:loaded].each { |name| remove_const( name ) } ; @autocode[:loaded] = [] ; end

      private

      old = method( :const_missing )
      (class << self ; self ; end ).instance_eval do
        define_method( :const_missing ) do | cname |
          constructors = @autocode[:constructors][true] + @autocode[:constructors][cname]
          constructors.pop.call( cname ) until ( const_defined?( cname ) or constructors.empty? )
          return old.call( cname ) unless const_defined?( cname )
          initializers = @autocode[:initializers][true] + @autocode[:initializers][cname]
          initializers.pop.call( cname ) until initializers.empty?
          @autocode[:loaded] << cname ; const_get( cname )
        end
      end
    end
  end
end
Autocode = AutoCode