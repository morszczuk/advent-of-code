require 'uri'
require 'net/http'

class DayInputFetcher
  SESSION_COOKIE = "session=#{ENV['AOC_SESSION_KEY']}".freeze

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
