#!/usr/bin/env ruby
#
#
DISTRIBUTION_LIST = ENV['DISTRIBUTION_LIST'] || 'robertjd333@gmail.com'
API_KEY= ENV['API_KEY'] || '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'

require "./lib/greenbot.rb"
require 'mail'

Mail.defaults do
 # delivery_method :smtp, {   :address    => "smtp.sendgrid.net",
 #                         :port       => 25,
 #                         :user_name  => 'apikey',
 #                         :password   => API_KEY,
 #                         :authentication => 'plain',
 #                         :enable_starttls_auto => true }
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",                                                     
      :port      => 25,                                                                     
      :user_name => "apikey",                                                                
      :password  => API_KEY, 
      :authentication => 'plain',                                                            
      :enable_starttls_auto => true }
end

extraInfo = gets
bodyText = "A new session has started" + extraInfo

Mail.deliver do
  to   DISTRIBUTION_LIST
  subject "Hello Friend"
  from 'noreply@tendigittext.com'
  body bodyText
end

puts "Email sent"
puts DISTRIBUTION_LIST
