#!/usr/bin/env ruby

module BitBot
  module Plugins
    module RobotFindsKitten
      @games={}

      extend Discordrb::Commands::CommandContainer

      command(:rfk, min_args: 1, max_args:1, description: 'Robot Finds Kitten: a game for robots finding kittens', usage: '!rfk (status|guess)')  do |event, guess|

        #pp event
        # Type (0: text, 1: private, 2: voice, 3: group

        # Ensure there's a game state hash we can query
        if @games[event.channel.id].nil?
          @games[event.channel.id]=Game.new
          puts "Created RFK Game instance for #{event.channel.id} (#{event.channel.type == 1 ? 'PM' : event.channel.server.name}/#{event.channel.name}) => #{guess}"
        else
          puts "RFK Game in #{event.channel.id} (#{event.channel.type == 1 ? 'PM' : event.channel.server.name}/#{event.channel.name}) => #{guess}"
        end

        case guess.downcase
        when 'a'..'z'
          @games[event.channel.id].guess(guess,event)
        when 'start'
          @games[event.channel.id].start
        when '#'
          'Stop looking in the mirror'
        when 'winners'
          'Sorry we don\'t keep winner stats yet'
        when 'status'
          @games[event.channel.id].status
        end

      end

      class Game
        def initialize
          @status=:new
          @guesses=[]
          @nki={}
          @kitten=nil
          @winner=""
          # TODO Winner Stats
        end
        # Starts a new game
        def start
          case @status
          when :new, :finished
            @guesses.clear
            @nki.clear

            # Where's the kitten
            @kitten = ('a'.ord+rand(26)).chr

            # Populate nki for non kitten letters
            ('a'..'z').each do |l|
              # TODO Check we don't already have this NKI
              @nki[l] = NonKittenItem.get unless l == @kitten
            end
            @status=:running
            p @nki
            'A new RFK game has started, can **you** find the kitten?'
          when :running
            "There's a game running already are you sure you want to restart (you've got to win first)"
          else
            puts "We got a start message but not in a known state of #{@state}"
            "Wibble not sure what's happening here"
          end
        end

        # Deal with a Guess
        def guess(guess,event)
          case @status
          when :new, :finished
            'You need to start a game first: `!rfk start`'
          when :running
            if guess == @kitten
              # We currently get a warning trying to send a message and add a reaction
              # [WARN : ct-3 @ 2018-02-26 17:49:52.182] Locking RL mutex (key: [:channels_cid_messages_mid_reactions_emoji_me, 417679731291324417]) for 1.0 seconds preemptively
              #event.message.react('😸')  # Smiley Cat
              @status=:finished
              "Woo you found kitten"
            elsif @guesses.include?(guess)
              "someone already guessed `#{guess}`, the kitten doesn't move during a game"
            else
              @guesses << guess
              "You found `#{@nki[guess]}` but that's not a kitten!"
            end
          else
            puts "We got a guess of #{guess} but not in a known state of #{@state}"
            "Wibble not sure what's happening here"
          end
        end

        def status
          case @status
          when :new
            "No game currently running, start a new one with `!rfk start`"
          when :running
            "Game is going, current guesses: #{@guesses.sort.join(', ')}"
          when :finished
            "Game was won by #{@winner} Kitten was at #{@kitten}"
          end
        end
      end

      class NonKittenItem
        # TODO Save/Load from file
        # TODO Allow adding new NKI's
        # TODO NKI's limited to server

        @@nkis=[]
        @@nkis << %q("50 Years Among the Non-Kitten Items", by Ann Droyd)
        @@nkis << %q(A bottle of distilled water.)
        @@nkis << %q(A bowl of cherries.)
        @@nkis << %q(A brain cell. Oddly enough, it seems to be functioning.)
        @@nkis << %q(Biscuits.)
        @@nkis << %q(An unlicensed nuclear accelerator.)
        @@nkis << %q(It's either a mirror, or another robot.)
        @@nkis << %q(It's cute like a kitten, but isn't a kitten.)
        @@nkis << %q(It's an elvish sword of great antiquity.)
        @@nkis << %q(Marvin is complaining about the pain in the diodes down his left side.)
        @@nkis << %q(Look out! Exclamation points!)
        @@nkis << %q(Not kitten, just a packet of Kool-Aid(tm).)
        @@nkis << %q(Plenty of nothing.)
        @@nkis << %q(A Bitcoin)
        @@nkis << %q(The intermission from a 1930s silent movie.)
        @@nkis << %q(The Digital Millennium Copyright Act of 1998.)
        @@nkis << %q(That's just an old tin can.)
        @@nkis << %q(A Dog. Woof!)
        @@nkis << %q(Tweeting birds.)
        @@nkis << %q(Whatever it is, it's circular. Oh, it's a circle!)
        @@nkis << %q(You can't touch that.)
        @@nkis << %q(You found kitten! No, just kidding.)
        @@nkis << %q(This is a disaster area.)
        @@nkis << %q(Tea and/or crumpets.)
        @@nkis << %q(Snacky things.)
        @@nkis << %q(Ooh, shiny!)
        @@nkis << %q(Ne'er but a potted plant.)
        @@nkis << %q(Just the usual gang of idiots.)

        def initialize
        end

        # Get a random NKI
        def self.get
          @@nkis[rand(@@nkis.count)]
        end

      end
      # Config
    end
  end # module Plugins
end # module BitBot
