class OrbiterController < AdminController

  force_ssl

  def edit
    if Orbiter.update_content( params[:id], params[:content] ) then
        redirect_to root_path
    end
  end

  def add
    if Orbiter.make then
        redirect_to root_path
    end
  end

  def destroy
    if Orbiter.drop_page( params[:id] ) then
        redirect_to root_path
    else
        puts "There was an error in a destroy request; the orbiter wasn't there to destroy."
        redirect_to root_path
    end
  end

end
