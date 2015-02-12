class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update]
  before_action :set_beer_clubs_for_template, only: [:new, :edit]
  before_action :set_membership_to_delete, only: [:destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)

    respond_to do |format|
      if current_user.nil?
        redirect_to signin_path, notice: 'you must be signed in to join a club'
      elsif @membership.save
        format.html { redirect_to beer_club_path(@membership.beer_club), notice: "#{current_user.username}, welcome to the club!" }
        format.json { render :new, status: :created, location: @membership }
      else
        set_beer_clubs_for_template
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Your membership in #{@beer_club} was ended." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end

    def set_beer_clubs_for_template
      @beer_clubs = BeerClub.all
    end

    def set_membership_to_delete
      @membership = Membership.find_by(:beer_club_id => params[:membership][:beer_club_id], :user_id => current_user.id)
      @beer_club = BeerClub.find(params[:membership][:beer_club_id])
    end  
end
