class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy, :approve, :disapprove]
  before_action :set_work, only: [:new, :show, :edit, :update, :destroy, :create]

  def new
    @app = App.new(work_id: @work.id)
  end

  def create
    if current_user
      @app = App.new(app_params)
      @app.user = current_user
      @app.work = @work
      if @app.save!
        flash[:success] = 'Art Request Application successfully submitted.'
        redirect_to work_app_path(@app.work_id, @app.id)
      else
        flash[:danger] = 'Could not save application.'
        redirect_to work_apps_path(@work)
      end
    else
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  def show
    if current_user == @app.user || current_user.admin?
      render 'show'
    else
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  def index
    if current_user
      @apps = App.where(user: current_user)
      render 'index'
    end
  end

  def edit
    if @app.user == current_user
      render 'edit'
    end
  end

  def update
    if current_user == @app.user && @app.update(app_params)
      flash[:success] = 'Application was successfully updated.'
      redirect_to(work_app_path(@work, @app))
    else
      flash[:error] = 'Could not update application.'
      render 'edit'
    end
  end

  def destroy
    if current_user == @app.user
      @app.destroy
      redirect_to work_apps_path
    else
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  def admin_index
    if current_user.admin?
      @apps = App.all.order(:id)
      render 'admin_index'
    end
  end

  def approve
    @app.approve(true)
    redirect_to apps_admin_path
  end

  def disapprove
    @app.approve(false)
    redirect_to apps_admin_path
  end


  private
    def set_app
      @app = App.find(params[:id])
    end

    def set_work
      @work = Work.find(params[:work_id])
    end

    def app_params
      params.require(:app).permit(:comment, :organization, :work_id)
    end

end
