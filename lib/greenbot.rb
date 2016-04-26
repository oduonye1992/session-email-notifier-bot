require 'rubygems'
require 'byebug'
require 'bundler/setup'
require 'highline/import'
require 'yaml'
require 'json'
require 'redis'
require 'uuidtools'
require 'airbrake'
require 'timeout'

if ENV['DEVELOPER'] == "true"
  FIVE_MINUTES = 5
  HALF_AN_HOUR = 30
  MESSAGE_PACE = 1
  at_exit byebug if $!
else
  FIVE_MINUTES = 5*60
  HALF_AN_HOUR = 30*60
  MESSAGE_PACE = 3.1415
  at_exit {
    e = $!
    unless e.nil?
      Airbrake.notify_or_ignore($!, {
        error_message: e.message,
        backtrace: e.backtrace,
        cgi_data: ENV.to_hash
        })
        exit!
    end
  }
end

# Handles the collection and remembering of data
class SessionData
  attr_accessor :collected_data
  def initialize(session_id = nil)
    @collected_data = {}
  end

  def remember(key, value)
    return if key.empty?
    collected_data[key] = value
    update_record
  end

  def forget(key)
    @collected_data.delete(key) if @collected_data.keys.include?(key)
    update_record
  end

  def update_record
    puts @collected_data.to_json
  end
end

# Extends ruby object to remember and forget them
class Object
  def remember(label)
    $session.remember(label, self)
  end
  def forget(label)
    $session.forget(label)
  end
end

# Helper classes
def confirm(prompt)
  positives = %w(yes sure OK yep)
  negatives = %w(no nope noway)
  answer = ask(prompt+"(y/n)").chomp.downcase
  answered = false
  while not answered
    positives.each do |p|
      return true if answer.include? p
    end
    negatives.each do |p|
      return false if answer.include? p
    end
    return true if answer == "y"
    return false if answer == "n"
    answer = ask("I'm sorry, we are looking for a Y or an N").chomp.downcase
  end
end

def select(prompt, choices)
  display_prompt = prompt + " (" + choices.sort.join(",") + ")"
  answer = ask(display_prompt)
  begin
    choices.each {|e|
      return e if e.downcase == answer.downcase
    }
    answer = ask("I'm sorry, please pick one : " + choices.join(","))
  end while true
end

def confirmed_gets(prompt)
  begin
    new_setting = ask(prompt)
    did_it_right = confirm("Did you send that correctly? Please check.")
    return new_setting if did_it_right
  end while not did_it_right
end

def listen
  $stdout.flush
  gets.chomp
end

def ask(prompt, first_timeout = FIVE_MINUTES, second_timeout = HALF_AN_HOUR)
  tell(prompt, 0)

  # Wait for the first timeout.
  # if the gets.chomp returns, we exit the block, return value, no worry
  # If not, we repeat the prompt
  answered = false
  answer = ''
  begin
    Timeout::timeout(first_timeout) do
      answer = gets.chomp
      answered = true
    end
  rescue Timeout::Error
    tell(prompt, 0)
  end
  return answer if answered

  begin
    Timeout::timeout(second_timeout) do
      answer = gets.chomp
      answered = true
    end
  rescue Timeout::Error
    tell('Thank you for contacting us. Closing this conversation, feel free to message us again to start again',0)
    exit
  end
  return answer if answered
end


def tell(prompt, pace = MESSAGE_PACE)
  puts prompt
  $stdout.flush
  sleep pace
end

def note(prompt)
  complete = false
  note = ""
  response = ask(prompt)
  begin
    if response.chomp.length == 1
      complete = true
      tell "Note taking mode complete."
    else
      note << response
      response = ask("Still listening here. Send as many messages as you like, send a Q to end. ")
    end
  end while not complete
  return note
end

$session = SessionData.new()
%w(SRC DST SESSION_ID).each do |s|
  $session.remember(s,ENV[s])
end
