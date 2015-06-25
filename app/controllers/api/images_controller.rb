class Api::ImagesController < ApplicationController
  include HttpResponseConcern

  def index
    render json: Image.all
  end

  def create
      image = Image.new(image_params)
      image.save ? render_200_image : render_500_error(image)
  end

  def delete
    begin
      image = Image.find(params[:id])
      image.destroy
      image.destroyed? ? render_200_nothing : render_500_error(image)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  def update
    begin
      image = Image.find(params[:id])
      image.update_attributes(image_params) ? render_200_image : render_500_error(image)
    rescue ActiveRecord::RecordNotFound => e
      render_500_ar_not_found e
    end
  end

  private
  def image_params
    params.require(:image).permit(:repo, :name)
  end

  def render_200_image
    render status: 200, json: { image: image }
  end
end
