#!/usr/bin/env ruby

require 'bittrex'
require 'bigdecimal'
require 'bigdecimal/util'

#require 'discordrb'

module BitBot
  module Plugins
    module Bittrex
      extend Discordrb::Commands::CommandContainer

      command(:bittrex, min_args: 0, max_args:2, description: 'List current price on Bittrex for a coin', usage: 'markets [market] [market]')  do |event, market1, market2|
        markets=[]
        if market2
          markets << market1.upcase
          markets << market2.upcase
        elsif market1
          markets << 'BTC'
          markets << market1.upcase
        else
          markets = %w(BTC EGC)
          # TODO look this up in server config
        end
        #puts "Looking up #{markets.join('-')} for ..."
        #pp event
        bittrex=::Bittrex::Quote.current(markets.join('-'))
        # TODO Volume
        "last: #{bittrex.last.to_d.to_s('4F')}, Bid: #{bittrex.bid.to_d.to_s('4F')}, Ask: #{bittrex.ask.to_d.to_s('4F')}"
      end


      # Config
    end
  end
end
