module URI
  ##
  # Pseudo-OrientDB URI handler
  class OrientDB < Generic
    DEFAULT_PORT = 2480
    
    def database
      path[0] == '/' ? path[1..-1] : path
    end
    
    def database=(value)
      path = "/#{value}"
    end
    
    def ssl?
      false
    end
    
  end

  @@schemes['ORIENTDB'] = OrientDB
 
end