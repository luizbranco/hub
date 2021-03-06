class LikesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource :like, :through => :user
  
  respond_to :html, :xml, :json
  
  def vote
    @user = current_user
    @build = Build.find(params[:build_id])
    @like = Like.vote(@user,@build)
    if @like.update_attributes(params[:like])
    else
      flash[:error] = "Bummer! Something went wrong!"
      redirect_to user_build_path(@build.user,@build)
    end
  end
  
  def create
    @user = current_user
    @build = Build.find(params[:build_id])
    @like = @user.likes.build(params[:like])
    if @build.user == @user
      flash[:error] = "You can't Like your own build!"
    else
      @like.build = @build
      if @like.save
      else
        flash[:error] = "Bummer! Something went wrong!"
        redirect_to user_build_path(@build.user,@build)
      end
    end
  end
  
  def update
    @user = current_user
    @build = Build.find(params[:build_id])
    @like = @user.has_voted?(@build)
    if @like.update_attributes(params[:like])
    else
      flash[:error] = "Bummer! Something went wrong!"
      redirect_to user_build_path(@build.user,@build)
    end
  end
  
end
