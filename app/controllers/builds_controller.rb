class BuildsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :user
  load_and_authorize_resource :build, :through => :user
  
  respond_to :html, :xml, :json
  set_tab :allbuilds
  set_tab :mybuilds, :if => :current_user?

  def index
    @title = "Explore the Diablo 3 builds of #{@user.name}"
    @user = User.find(params[:user_id])
    respond_with(@builds = @user.builds)
  end

  def new
    @title = "New build"
    @user = User.find(current_user.id)
    @build = @user.builds.build
    @build_types = BuildType.all
    9.times do
      build_skills = @build.build_skills.build
    end
  end

  def create
    @user = User.find(params[:user_id])
    @build = @user.builds.build(params[:build])
    if @build.save
      flash[:notice] = "Build created!"
      respond_with(@build, :location => user_build_path(@user,@build))
    else
      flash[:error] = "Bummer! Something went wrong!"
      redirect_to user_builds_url(@user)
    end
  end

  def show
    @user = User.find(params[:user_id])
    @build = Build.find(params[:id])
    @build_skills = @build.build_skills
    @comments = @build.comments
    @title = "#{@build.name} #{@build.char_class.name} built by #{@user.name}"
    @description = @build.description.truncate(150)
  end

  def edit
    @title = "Edit Build"
    @user = User.find(params[:user_id])
    @build = @user.builds.find(params[:id])
    @char = @build.char_class
    @build_types = BuildType.all
  end

  def update
    @user = User.find(params[:user_id])
    @build = Build.find(params[:id])
    @build.attributes = {'build_type_ids' => []}.merge(params[:build] || {})
    if @build.update_attributes(params[:build])
      flash[:notice] = "Build updated"
      respond_with(@build, :location => user_build_path(@user,@build))
    else
      flash[:error] = "Bummer! Something went wrong!"
      redirect_to edit_user_build_path(@user,@build)
    end
  end

  def destroy
    @user = User.find(current_user.id)
    @build = Build.find(params[:id])
    if @build.destroy
      flash[:notice] = "Build deleted!"
      redirect_to user_builds_url(@user)
    else
      flash[:error] = "Bummer! Something went wrong!"
      redirect_to user_builds_url(@user)
    end
  end
  
  def current_user?
    @user = User.find(params[:user_id])
    @user == current_user
  end
  
 def login
    @user = User.find(params[:user_id])
    @build = Build.find(params[:id])
    location = params[:location]
    redirect_to user_build_path(@user,@build, :anchor => location)
  end
end

