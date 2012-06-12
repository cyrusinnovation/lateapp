class StoreHelper
  def self.model_restricted_to_entities_named(names_arr)
    m = NSManagedObjectModel.mergedModelFromBundles(nil)
    m.entities = m.entities.select{|e| names_arr.include?(e.name)}
    m
  end
end