class GameDaysController < ApplicationController
  GAME_WEEK_KEY = :game_week
  PLAYER_ID_KEY = :player_id

  def which_team_has_player
    validate_all_parameters([GAME_WEEK_KEY, PLAYER_ID_KEY], params)

    game_week = params[GAME_WEEK_KEY]
    nfl_player = NflPlayer.find(params[PLAYER_ID_KEY])
    match_player = nfl_player.player_for_game_week(game_week)

    game_week_team_players = GameWeekTeamPlayer.where(match_player: match_player)
    found_user = nil if game_week_team_players.empty?
    found_user = game_week_team_players.first.game_week_team.user unless game_week_team_players.empty?

    return_data = nil if found_user.nil?
    return_data = {
      name: found_user.name,
      team_name: found_user.team_name,
      playing: game_week_team_players.first.playing
    } unless found_user.nil?

    render json: { data: return_data }, status: :success
  end

  private

  def find_player(users, _name, game_week)
    users.each do |user|
      user.team_for_game_week(game_week).match_players do |match_player|
        return user if match_player.nfl_player.name
      end
    end
    nil
  end
end