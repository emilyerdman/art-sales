class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :approve, :disapprove, :change_user_category]


  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.admin?
      @users = User.all.order(:id)
    else
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user != @user
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if current_user != @user
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.approved = false
    @user.category = User.categories['posters']
    @user.email = @user.email.downcase
    if @user.save
      log_in @user
      flash[:success] = "Account created and user logged in successfully. You will need to wait for an administrator to approve your account before you can access the works. Please contact help@erdman-art-group.com with any questions or concerns."
      redirect_to @user
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user == @user && @user.update(user_params)
      redirect_to(@user, notice: 'User was successfully updated.')
    else
      format.html { render :edit }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user == @user
      @user.destroy
      log_out
      redirect_to root_url
    elsif current_user.admin?
      @user.destroy
      redirect_to users_path
    else
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  def approve
    @user.approve_user(true)
    redirect_to users_path
  end

  def disapprove
    @user.approve_user(false)
    redirect_to users_path
  end

  def change_user_category
    begin
      @user.change_user_category(params[:category])
      @user.save
      redirect_to users_path
    rescue StandardError => e
      @error = e
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone, :company, address: [:street_address, :city, :state, :zip_code, :country])
    end
end
