require 'riot_lol_api/model/player_stat_summaries'
require 'riot_lol_api/model/player_stat_ranks'
require 'riot_lol_api/model/pages'
require 'riot_lol_api/model/games'
require 'riot_lol_api/model/leagues'
require 'riot_lol_api/model/matches'
require 'riot_lol_api/model/participants'
require 'riot_lol_api/model/timelines'
require 'riot_lol_api/model/creepspermindeltas'
require 'riot_lol_api/model/xppermindeltas'
require 'riot_lol_api/model/goldpermindeltas'
require 'riot_lol_api/model/csdiffpermindeltas'
require 'riot_lol_api/model/xpdiffpermindeltas'
require 'riot_lol_api/model/damagetakenpermindeltas'
require 'riot_lol_api/model/damagetakendiffpermindeltas'
require 'riot_lol_api/model/participantidentities'
require 'riot_lol_api/model/players'
require 'riot_lol_api/model/observers'
require 'riot_lol_api/model/game_lists'
require 'riot_lol_api/model/banned_champions'
require 'riot_lol_api/model/teams'
require 'riot_lol_api/model/bans'

module RiotLolApi
  module Model
    class Summoner
      include RiotLolApi::HelperClass

      # attr needs @id, @region
      SEASON_TAB = %(SEASON2016, SEASON2015, SEASON2014, SEASON3)
      def initialize(options = {})
        options.each do |key, value|
          self.class.send(:attr_accessor, key.to_sym)
          instance_variable_set("@#{key}", value)
        end
      end

      def masteries
        response = @client.get(url: "#{@region}/v1.4/summoner/#{@id}/masteries", domaine: @region)
        return nil if response.nil?
        tab_pages = []
        response[id.to_s]['pages'].each do |page|
          tab_pages << RiotLolApi::Model::Page.new(page.lol_symbolize)
        end
        tab_pages
      end

      def runes
        response = @client.get(url: "#{@region}/v1.4/summoner/#{@id}/runes", domaine: @region)
        return nil if response.nil?
        tab_pages = []
        response[id.to_s]['pages'].each do |page|
          tab_pages << RiotLolApi::Model::Page.new(page.lol_symbolize)
        end
        tab_pages
      end

      def games
        response = @client.get(url: "#{@region}/v1.3/game/by-summoner/#{@id}/recent", domaine: @region)
        return nil if response.nil?
        tab_games = []
        response['games'].each do |game|
          tab_games << RiotLolApi::Model::Game.new(game.lol_symbolize)
        end
        tab_games
      end

      def stat_summaries(season = 'SEASON2015')
        response = @client.get(url: "#{@region}/v1.3/stats/by-summoner/#{@id}/summary", domaine: @region, data: { season: season })
        return nil if response.nil?
        tab_stat_summaries = []
        response['playerStatSummaries'].each do |stat_summary|
          tab_stat_summaries << RiotLolApi::Model::PlayerStatSummary.new(stat_summary.lol_symbolize)
        end
        tab_stat_summaries
      end

      def stat_ranks(season = 'SEASON2015')
        response = @client.get(url: "#{@region}/v1.3/stats/by-summoner/#{@id}/ranked", domaine: @region, data: { season: season })
        return nil if response.nil?
        tab_stat_ranks = []
        response['champions'].each do |stat_rank|
          tab_stat_ranks << RiotLolApi::Model::PlayerStatRank.new(stat_rank.lol_symbolize)
        end
        tab_stat_ranks
      end

      def get_league_stats
        response = @client.get(url: "#{@region}/v2.5/league/by-summoner/#{@id}/entry", domaine: @region)
        return nil if response.nil?
        tab_league_stats = []
        response["#{@id}"].each do |league_stat|
          tab_league_stats << RiotLolApi::Model::League.new(league_stat.lol_symbolize)
        end
        tab_league_stats
      end

      def match_list
        response = @client.get(url: "#{@region}/v2.2/matchlist/by-summoner/#{@id}", domaine: @region)
        return nil if response.nil?
        response['matches'].map { |match_history| RiotLolApi::Model::Match.new(match_history.lol_symbolize) }
      end

      def current_game(platform_id = 'EUW1')
        response = @client.get(url: "observer-mode/rest/consumer/getSpectatorGameInfo/#{platform_id}/#{@id}", domaine: @region, overide_base_uri: 'api.pvp.net/')
        return nil if response.nil?
        RiotLolApi::Model::Game.new(response.lol_symbolize)
      end

      def profile_icon
        "#{RiotLolApi::Client.realm['cdn']}/#{RiotLolApi::Client.realm['v']}/img/profileicon/#{profile_icon_id}.png"
      end
    end
  end
end
