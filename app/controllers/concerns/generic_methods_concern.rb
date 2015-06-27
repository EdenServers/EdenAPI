module GenericMethodsConcern
  extend ActiveSupport::Concern

  def delete_object(object, id)
    begin
      item = object.find(id)
      item.destroy
      item.destroyed? ? render_200_nothing : render_500_error(item)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  def update_object(object, id)
    begin
      item = object.find(id)
      item.update_attributes(image_params) ? render_200_object(item) : render_500_error(image)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end
end