class UtilitiesController < ActionController::Base

  # GET /utilities/color/{color}
  def color
    @color = params[:color]

    respond_to do |format|
      format.html
    end

  end

end
