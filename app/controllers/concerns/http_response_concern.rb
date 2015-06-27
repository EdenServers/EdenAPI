module HttpResponseConcern
  extend ActiveSupport::Concern

  def render_500_error(object)
    render status: 500, json: { error: object.errors }
  end

  def render_500_ar_not_found(error)
    render status: 500, json: { error:  error }
  end

  def render_200_nothing
    render status: 200, json: nil
  end

  def render_200_object(object)
    render status: 200, json: object
  end
end