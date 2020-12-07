require 'uri'
require 'net/http'

class DayInputFetcher
  SESSION_COOKIE = 'session=53616c7465645f5f214b5673f8e676d40556765dc5a6006f07e2a06731ef9d481c6e9d07ada1a7a12e111c367e612da9'.freeze

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
