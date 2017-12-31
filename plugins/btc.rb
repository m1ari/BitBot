#!/usr/bin/env ruby

require 'blockchain'
#require 'bigdecimal'
#require 'bigdecimal/util'

#require 'discordrb'

module BitBot
  module Plugins
    module BitCoin
      extend Discordrb::Commands::CommandContainer

      command(:btc, min_args:0, description: 'List current price for BTC in fiat, multiple currencies can be listed', usage: 'btc [currency]' ) do |event, *currency|
        explorer = Blockchain::ExchangeRateExplorer.new
        ticker = explorer.get_ticker
        currency << 'USD' if currency.empty?
        # TODO Should we only allow help if there's no other arguments
        out = []
        currency.each do |curr|
          if curr.downcase == 'help'
            event << "Help: *!btc [Currency]*"
            event << "Help: *Currency can be one of #{ticker.keys.join(', ')}*"
          elsif ticker[curr.upcase].nil?
            event << "Info: *Currency #{curr} not found*"
          else
            out << "%s%.2f" % [ticker[curr.upcase].symbol, ticker[curr.upcase].last]
          end
        end
        out.join(' ')
      end

      # Config
    end
  end
end
