class WikisController < ApplicationController
  # before_action :privacy_update
  def users_name
    'username'
  end

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @collabs = @wiki.users
  end

  def new
    @wiki = Wiki.new
    @collabs = Collaborator.where(wiki_id: @wiki.id)
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    @collabs = Collaborator.where(wikis_id: @wiki.id)

    if @wiki.save
      flash[:notice] = 'Wiki was saved.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error saving the wiki. Please try again.'
      render :new
    end
   end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @collabs = @wiki.collaborators
    @new_collabs = User.all
  end

  def update
    @wiki = Wiki.find(params[:id])

    @wiki.assign_attributes(wiki_params)

    if @wiki.save
      wiki_collaborators_path(@wiki)
      flash[:notice] = 'wiki was updated.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'Error saving wiki. Please try again.'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = 'There was an error deleting the wiki.'
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def privacy_update
    @wikis = Wiki.all

    @wikis.each do |wiki|
      wiki.update_attributes(private: false) if wiki.user.standard?
    end
  end
end
