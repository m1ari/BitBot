#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/settings'
require_relative 'lib/plugins'
#require 'bigdecimal'
#require 'bigdecimal/util'

require 'discordrb'

# Load settings from EGCChipBot.yaml
Settings.load! "config.yaml"

bot = Discordrb::Commands::CommandBot.new client_id: Settings.discord[:client_id], token: Settings.discord[:bot_token], prefix: '!'


require_relative 'plugins/bittrex'
bot.include! BitBot::Plugins::Bittrex

require_relative 'plugins/btc'
bot.include! BitBot::Plugins::BitCoin

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
