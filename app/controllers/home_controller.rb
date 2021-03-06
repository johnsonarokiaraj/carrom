class HomeController < ApplicationController
  def index
    @matches = Match.all
  end

  def team_list
    @matches = Match.all
    @available_players = Player.available_players
    @team = Team.order('id ASC')
  end

  def show_player
    @team = Team.order('id ASC')    
    @player = Player.get_random_player
    render_success("show_player", player: @player, team: @team)
  end

  def assign_player
    @player = Player.find(params[:id])
    @player.update(player_params)
    redirect_to root_path
  end

  def match_list
    @matches = Match.order(match_no: :asc)
  end

  def results
    @matches = Match.order(match_no: :asc)
    @teams = Team.order('id ASC')
    @players = Player.order('id ASC')
  end

  def player_params
    params.require(:player).permit(:name, :score, :team_id, :image)
  end
end
