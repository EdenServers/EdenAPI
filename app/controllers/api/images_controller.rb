class Api::ImagesController < ApplicationController
  def index
    render json: Image.all
  end

  def create
      image = Image.new(image_params)
      image.save ? render(status: 200, json:{ image: image }) : render(status: 500, json: { error: image.errors })
  end

  def delete
    begin
      image = Image.find(params[:id])
      image.destroy
      image.destroyed? ? render(:nothing, status: 200) : render(status: 200, json: { error: image.errors })
    rescue ActiveRecord::RecordNotFound => e
      render status: 500, json: { error:  e }
    end
  end

  def update
    begin
      image = Image.find(params[:id])
      image.update_attributes(image_params) ? render(status: 200, json: { image: image }) : render(status: 500, json: { error: image.errors })
    rescue ActiveRecord::RecordNotFound => e
      render status: 500, json: { error:  e }
    end
  end

  private
  def image_params
    params.require(:image).permit(:repo, :name)
  end
end
