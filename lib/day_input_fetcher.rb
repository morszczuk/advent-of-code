require 'uri'
require 'net/http'

class DayInputFetcher
  SESSION_COOKIE = 'session=53616c7465645f5fb09ea1826dd15a5e710c6609536b2ba1c92bad5c821552c22f30743b29a9ae08e63ac2dfb559bebb'.freeze

  def initialize(year, day)
    @uri = URI.parse("https://adventofcode.com/#{year}/day/#{day}/input")
  end

  def call
    req = Net::HTTP::Get.new(@uri)
    req['Cookie'] = SESSION_COOKIE

    res = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    res.body
  end
end


# session_cookie =


# puts res.body # <!DOCTYPE html> ... </html> => nil
