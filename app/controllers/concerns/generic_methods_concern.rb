module GenericMethodsConcern
  extend ActiveSupport::Concern

  def delete_object(object, id)
    begin
      item = object.find(id)
      item.destroy
      item.destroyed? ? render_200_nothing : render_500_object_error(item)
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  def show_object(object, id)
    begin
      item = object.find(id)
      render_200_object(item)
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end

  def update_object(object, id, params)
    begin
      item = object.find(id)
      item.update_attributes(params) ? render_200_object(item) : render_500_object_error(item)
    rescue ActiveRecord::RecordNotFound => e
      render_500_error e
    end
  end
end