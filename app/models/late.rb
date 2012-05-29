class Late < NSManagedObject
  def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = 'Late'
      entity.managedObjectClassName = 'Late'
      entity.properties = 
        [
          'date', NSDateAttributeType,
          'how_late', NSInteger16AttributeType
        ].each_slice(2).map do |name, type|
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
