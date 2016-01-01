module URI
  ##
  # Pseudo-OrientDB URI handler
  class OrientDB < Generic
    DEFAULT_PORT = 2480
    
    def database
      return nil unless self.path.present?
      self.path[0] == '/' ? self.path[1..-1] : self.path
    end
    
    def database=(value)
      self.path = value.present? ? "/#{ value }" : ''
    end
    
    def ssl?
      false
    end
    
  end

  @@schemes['ORIENTDB'] = OrientDB
 
end