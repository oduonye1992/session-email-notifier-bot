#!/usr/bin/env ruby
#
#
PROMPT_1 = ENV['PROMPT_1'] || 'Default prompt 1'
PROMPT_2 = ENV['PROMPT_2'] || 'Default prompt 2'
PROMPT_3 = ENV['PROMPT_3'] || 'Default prompt 3'
SIGNATURE = ENV['SIGNATURE'] || 'Default signature prompt'


require "./lib/greenbot.rb"
tell PROMPT_1
issue = note(PROMPT_2)
if confirm("Would you like someone to contact you?")
  contact_me = true
  contact_me.remember("contact_me")
  name = ask("When we call, who should we ask for?")
  name.remember("who_to_ask_for")
  if confirm("Is there another number we should try?")
    better_number = ask("Please enter that number with an area code")
    better_number.remember("better_number")
  end
else
  tell("No problem at all.")
end
tell PROMPT_3
tell SIGNATURE

