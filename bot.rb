#!/usr/bin/env ruby

DISTRIBUTION_LIST = ENV['DISTRIBUTION_LIST']
API_KEY= ENV['API_KEY']
MAIL_ADDRESS= ENV['MAIL_ADDRESS'] 
MAIL_PORT= ENV['MAIL_PORT']
MAIL_PASSWORD= ENV['MAIL_PASSWORD'] 
MAIL_USER_NAME= ENV['MAIL_USER_NAME'] 
MAIL_SUBJECT= ENV['MAIL_SUBJECT']
MAIL_BODY= ENV['MAIL_BODY']

require "./lib/greenbot.rb"
require 'mail'

Mail.defaults do
  delivery_method :smtp, { :address   => MAIL_ADDRESS,                                                     
      :port      => MAIL_PORT,                                                                     
      :user_name => MAIL_USER_NAME,                                                                
      :password  => MAIL_PASSWORD, 
      :authentication => 'plain',                                                            
      :enable_starttls_auto => true }
end

extraInfo = gets
bodyText = MAIL_BODY + " " + extraInfo

Mail.deliver do
  to   DISTRIBUTION_LIST
  subject MAIL_SUBJECT
  from 'noreply@tendigittext.com'
  body bodyText
end

puts "Email sent"
