Discord Bot for Crypto Currencies

* Price Trackers

To add the production bot to your server use
https://discordapp.com/oauth2/authorize?&client_id=387211236649205771&permissions=3072&scope=bot

For support / Testing use the Discord server
https://discord.gg/7ZgWeCq

# Installation
Clone from github
 git clone ...

Install required Gems
 bundle install --path vendor/bundle

# Configure
Copy the config.yaml.template to config.yaml and add in the suitable values

# Run
run ./bot.rb

# Developers
To test the bot on your own system you'll need to create a new App at
https://discordapp.com/developers/applications/me
You will need to put the client_id into the Config file

Then within the Application Create a Bot User
You will need to put the bot Token into the config file

Public Bot: Off
Require OAuth2 Code Grant: Off
