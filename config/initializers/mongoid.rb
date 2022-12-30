# config/initializers/mongoid.rb
module Mongoid
  module Document
    def as_json(options = {})
      attrs = super(options)
      attrs['id'] = attrs['_id']['$oid']
      attrs.delete('_id')
      attrs
    end
  end
end
