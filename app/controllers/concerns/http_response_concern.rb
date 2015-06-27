module HttpResponseConcern
  extend ActiveSupport::Concern

  def render_500_error(object)
    render status: 500, json: { error: object.errors }
  end

  def render_500_ar_not_found(error)
    render status: 500, json: { error:  error }
  end

  def render_200_nothing
    render :nothing, status: 200
  end

  def render_200_image
    render status: 200, json: { image: image }
  end

  def render_200_container
    render status: 200, json: { container: container }
  end
end