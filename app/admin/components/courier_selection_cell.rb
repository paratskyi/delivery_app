class CourierSelectionCell < ActiveAdmin::Component
  builder_method :courier_selection_cell

  def build(resource)
    input type: 'checkbox',
          id: resource.id,
          value: resource.id,
          class: 'collection_selection',
          name: 'courier_ids[]'
  end
end
