#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/settings'
require 'bittrex'
require 'blockchain'
require 'bigdecimal'
require 'bigdecimal/util'

require 'discordrb'

# Load settings from EGCChipBot.yaml
Settings.load! "config.yaml"

bot = Discordrb::Commands::CommandBot.new client_id: Settings.discord[:client_id], token: Settings.discord[:bot_token], prefix: '!'

bot.command(:bittrex, min_args: 0, max_args:2, description: 'List current price on Bittrex for a coin', usage: 'markets [market] [market]')  do |event, market1, market2|
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
  bittrex=Bittrex::Quote.current(markets.join('-'))
  # TODO Volume
  "last: #{bittrex.last.to_d.to_s('4F')}, Bid: #{bittrex.bid.to_d.to_s('4F')}, Ask: #{bittrex.ask.to_d.to_s('4F')}"
end

bot.command(:btc, min_args:0, max_args:1, description: 'List current price for BTC in fiat', usage: 'btc [currency]' ) do |event, currency|
  explorer = Blockchain::ExchangeRateExplorer.new
  ticker = explorer.get_ticker
  curr = currency || 'USD'
  if curr.downcase == 'help'
    event << "!btc [Currency]"
    event << "Currency can be one of #{ticker.keys.join(', ')}"
  elsif ticker[curr.upcase].nil?
    "Currency #{curr} not found"
  else
    ticker[curr.upcase].last
  end
end

bot.server_create do |event|
  puts "Added to new server #{event.server.id} #{event.server.name}"
end

bot.server_delete do |event|
  puts "Removed from server server #{event.server.id} #{event.server.name}"
end

bot.run :async

# Perm 3072: View Channels, Send Message
puts "This bot's invite URL is #{bot.invite_url(permission_bits: 3072)}."
bot.servers.each do |id,server|
  puts "=== Server #{id} ==="
  puts "  Joined #{server.name}"
  # TODO Check we have settings for it somewhere ...
end

bot.sync
