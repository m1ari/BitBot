#!/usr/bin/env ruby

require 'coinmarketcap'
#require 'bigdecimal'
#require 'bigdecimal/util'

module BitBot
  module Plugins
    module CoinMarketCap
      extend Discordrb::Commands::CommandContainer

      command(:cmc, min_args: 0, max_args:1, description: 'CoinMarketCap details for a coin', usage: '!cmc [market]')  do |event, market|
        market = 'evergreencoin' if market.nil? # TODO Configurable based on server

        puts "CMC for #{market}"
        #pp event
        cmc=Coinmarketcap.coin(market,'BTC')

        case cmc.code
        when 200
          if cmc.count==1
            cmc = cmc[0]
            "CMC Price for #{cmc['symbol']} $#{cmc['price_usd'].to_f.round(2)} (#{cmc['price_btc']}BTC), Volume: $#{cmc['24h_volume_usd']} (#{cmc['24h_volume_btc'].to_f.round(2)}BTC), Rank: #{cmc['rank']}"
          end

        when 404
          "CMC Market #{market} not valid - you need to use the long name"
        else
          "CMC Error - Not sure what happened - Maybe try again in a bit"
        end

      end

      # Config
    end
  end
end

=begin
[{"id"=>"evergreencoin",
  "name"=>"EverGreenCoin",
  "symbol"=>"EGC",
  "rank"=>"597",
  "price_usd"=>"0.311325",
  "price_btc"=>"0.0000319993",
  "24h_volume_usd"=>"5039.21",
  "market_cap_usd"=>"4147254.0",
  "available_supply"=>"13321301.0",
  "total_supply"=>"13321301.0",
  "max_supply"=>nil,
  "percent_change_1h"=>"-0.5",
  "percent_change_24h"=>"0.34",
  "percent_change_7d"=>"-12.17",
  "last_updated"=>"1519647849",
  "24h_volume_btc"=>"0.5179506352",
  "market_cap_btc"=>"426.0"}]
=end
