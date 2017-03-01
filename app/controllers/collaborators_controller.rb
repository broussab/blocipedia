class CollaboratorsController < ApplicationController
  def new
    @collaborator = Collaborator.new
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.find(params[:collaborator][:user_id])
    @collaborator = @wiki.collaborators.build(user: @user)

    if @collaborator.save
      flash[:notice] = 'Collaborator added.'
      redirect_to edit_wiki_path(@wiki)
    else
      flash.now[:alert] = 'There was an error saving the collaborator. Please try again.'
      redirect_to @wiki
    end
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = "\"#{@collaborator.user.username}\" has been successfully removed."
      redirect_to wiki_path
    else
      flash.now[:alert] = 'There was an error removing the collaborator.'
      render edit_wiki_path
    end
  end
end
