class DomainsController < ApplicationController
  before_filter :authenticate_email!
  
  def index
    @domains = Domain.all
  end

  def show
    @domain = Domain.find(params[:id])
  end

  def edit
    @domain = Domain.find(params[:id])
  end

  def update
    @domain = Domain.find(params[:id])
    if @domain.update_attributes(params[:domain])
      @domain.emails.each(&:update_domain!)
      flash[:notice] = 'Domain was successfully updated.'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Enter correct domain name'
      redirect_to :action => 'edit'
    end
  end
  
  def new
    @domain = Domain.new #(:name =>"bimbam", :id => Domain.last.id)
     respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  
  def create
    @domain = Domain.new(params[:domain])
    if @domain.save
      flash[:notice] = 'Domain was successfully created.'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Enter correct domain name'
      redirect_to [:new,:domain]
    end
  end
  
  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy # will also destroy belonging emails
    flash[:notice] = "#{@domain.name} and all associated emails were successfully deleted."
    redirect_to domains_path
  end
end
