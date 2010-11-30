class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xmlurrent_user.name 
  def show_profile
    @user = User.find(:first, :conditions => [ "alias = ?", params[:alias]])

    respond_to do |format|
      format.html { render "/users/show" }
      format.xml  { render :xml => @user }
    end
  end
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @user }
    end
  end
    

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = UserSession.find
    if @user.nil?
      flash[:notice] = "Please log in to edit your profile. ;)"
      redirect_to(:controller => "user_session", :action => "new")
    elsif @user.user.id != params[:id].to_i
      flash[:notice] = "Silly goose.. You can't edit other users' profiles."
      redirect_to(:controller => "home", :action => "index")
    elsif @user.user.id == params[:id].to_i
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    # Check to see if the user's email ended in .edu
    # If not, they're just a regular user who needs to pay
    # ;)
    if ( params[:user][:email][-4,4] == ".edu" )
      @user.is_student = true
    end
    respond_to do |format|
      if @user.save
        UserMailer.activation_email(@user).deliver
        format.html { redirect_to(:controller => :home, :notice => "Your account has been created. Please check your e-mail for your account activation instructions!") }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
