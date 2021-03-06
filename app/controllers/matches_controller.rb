class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.order(match_no: :desc)
  end

  # GET /matches/new
  def new
    @match = Match.new
    @team = Team.all
    @player = Player.all
  end

  # GET /matches/1/edit
  def edit
    @team = Team.all
    @player = Player.all
  end

  # POST /matches
  # POST /matches.json
  def create    
    @match = Match.new(match_params)
    players_id = [params[:match]["player1"], params[:match]["player2"], params[:match]["player3"], params[:match]["player4"]]

    respond_to do |format|
      if @match.save
        players_id.each do |player_id|
          MatchPlayer.create(:match_id => @match.id, :player_id => player_id)
        end

        format.html { redirect_to matches_path, notice: 'Match was successfully created.' }
        format.json { render action: 'index', status: :created, location: @match }
      else
        format.html { render action: 'new' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update_attributes(
          :winning_team_id => params["match"]["winning_team"], 
          :queen_player_id => params["match"]["queen_holder"],
          :board_points => params["match"]["board_points"])
        format.html { redirect_to matches_path, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def player_edit
    @match = Match.find(params[:match_id])
  end

  def player_update
    @match = Match.find(params[:match_id])
    @player1 = MatchPlayer.where("player_id = ? AND match_id = ?", params["player1"]["id"], @match.id).first
    @player2 = MatchPlayer.where("player_id = ? AND match_id = ?", params["player2"]["id"], @match.id).first
    @player3 = MatchPlayer.where("player_id = ? AND match_id = ?", params["player3"]["id"], @match.id).first
    @player4 = MatchPlayer.where("player_id = ? AND match_id = ?", params["player4"]["id"], @match.id).first

    @player1.update_attributes(
      :coin_count => params["player1"]["coin_count"], 
      :opp_coin_count => params["player1"]["opp_coin_count"],
      :due_count => params["player1"]["dues_count"],
      )
    @player2.update_attributes(
      :coin_count => params["player2"]["coin_count"], 
      :opp_coin_count => params["player2"]["opp_coin_count"],
      :due_count => params["player2"]["dues_count"],
      )
    @player3.update_attributes(
      :coin_count => params["player3"]["coin_count"], 
      :opp_coin_count => params["player3"]["opp_coin_count"],
      :due_count => params["player3"]["dues_count"],
      )
    @player4.update_attributes(
      :coin_count => params["player4"]["coin_count"], 
      :opp_coin_count => params["player4"]["opp_coin_count"],
      :due_count => params["player4"]["dues_count"],
      )
    redirect_to match_player_edit_path(@match)
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:match_no, :match_date, :team1_id, :team2_id, :winning_team_id, :queen_team_id, :comments, :player1, :player2, :players3, :players4)
    end
end
