#!/usr/bin/env ruby
#
#
DISTRIBUTION_LIST = ENV['DISTRIBUTION_LIST'] || 'thomas.howe@tendigittext.com'
API_KEY= ENV['API_KEY'] || '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'

require "./lib/greenbot.rb"
require 'mail'

Mail.defaults do
  delivery_method :smtp,  :address    => "smtp.sendgrid.net",
                          :port       => 25,
                          :user_name  => 'apikey',
                          :password   => API_KEY,
                          :enable_ssl => true
end

extraInfo = gets
bodyText = "A new session has started" + extraInfo

mail = Mail.new do
  to   DISTRIBUTION_LIST
  from 'noreply@tendigittext.com'
  body bodyText
end

mail.deliver!

