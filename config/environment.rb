require 'pry'
require 'nokogiri'
require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

require_relative '../lib/game_info/cli'
require_relative '../lib/game_info/game'
require_relative '../lib/game_info/scraper'