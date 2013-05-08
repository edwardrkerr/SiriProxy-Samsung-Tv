require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::SamsungTv < SiriProxy::Plugin

  def initialize(config = {})
  end

  #get the user's location and display it in the logs
  #filters are still in their early stages. Their interface may be modified
  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"

    #Note about returns from filters:
    # - Return false to stop the object from being forwarded
    # - Return a Hash to substitute or update the object
    # - Return nil (or anything not a Hash or false) to have the object forwarded (along with any
    #    modifications made to it)
  end

  listen_for /time for bed/i do
	say "I think it is definitely past your bed time and Sophie will be angry!"
  end

  #
  # Turn the Tv off
  #

  listen_for(/TV off/i) { turn_tv_off }
  
  def turn_tv_off
	say "Sending the signal..."

	Thread.new {
	      status = system("cd ~/.siriproxy/plugins/siriproxy-samsungtv/ && ./tv.pl key=POWEROFF")

	      if status
		say "Samsung has powered down."
	      else
		say "Looks like the Samsung is already off!"
	      end
		
	      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
	}

  end

  # Change to Apple Tv
  listen_for(/apple tv/i) { turn_tv("HDMI", "Switching to the Apple Tv.", "") }

  # Change to normal tv
  listen_for(/normal tv/i) { turn_tv("TV", "Switching to bog standard television.", "Done") }

  # Mute/Unmute the tele
  listen_for(/mute/i) { turn_tv("MUTE", "", "Tele muted.") }
  listen_for(/restore tv volume/i) { turn_tv("MUTE", "", "Tele volume restored.") }

  # Function for managing the commands and passing to the perl script 
  def turn_tv(key, startText="", returnText="")
	if startText.length > 0
		say "#{startText}"
	end

	Thread.new {
	      status = system("cd ~/.siriproxy/plugins/siriproxy-samsungtv/ && ./tv.pl key=#{key}")

	      if status
		if returnText.length > 0
			say "#{returnText}"
		end
	      else
		say "I can't find a connection. Looks like the Samsung is switched off!"
	      end
		
	      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
	}

  end
  
  #
  # Change the tele volume by x amount
  #

  listen_for(/turn tv volume down by ([0-9,]*[0-9])/i) { |number| turn_volume("down", number) }
  listen_for(/turn tv volume up by ([0-9,]*[0-9])/i) { |number| turn_volume("up", number) }
  
  def turn_volume(direction, number)
	number = number.to_i
	say "Turning the volume #{direction} by #{number}"

	Thread.new {

	      i = 0
	      while i < number
		      i += 1
		      status = system("cd ~/.siriproxy/plugins/siriproxy-samsungtv/ && ./tv.pl key=VOL#{direction.upcase}")
	      end

	      if status
		say "Volume successfully turned #{direction}. Nice one champ!"
	      else
		say "I can't find a connection, looks like the Samsung is switched off!"
	      end
		
	      request_completed #always complete your request! Otherwise the phone will "spin" at the user!
	}

  end

end
