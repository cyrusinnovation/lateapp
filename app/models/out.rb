class Out < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Out'
      entity.managedObjectClassName = 'Out'
      entity.properties = 
        ['date', NSDateAttributeType].each_slice(2).map do |name, type|
            property = NSAttributeDescription.alloc.init
            property.name = name
            property.attributeType = type
            property.optional = false
            property
          end
      entity
    end
  end
  
  def new?
    self.managedObjectContext.nil?
  end  
end