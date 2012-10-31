require 'rubygems'
require 'httparty'
require File.dirname(__FILE__) + "/report.rb"

class Coned
  BOROS = ["Bronx" "Brooklyn", "Manhattan", "Queens", "Staten Island", "Westchester"]

  def initialize
    @response = HTTParty.get(coned_url_with_directory, :format => :json).parsed_response 
    @report = Report.new
  end

  def populate_worksheet
    @report.update_worksheet(worksheet_data)
  end

  private

  def worksheet_data
    current_time = Time.now.strftime("%m/%d/%Y %H:%M:%S")
    [current_time] + areas.collect { |area| area["custs_out"] || ""}
  end

  def areas
    @response["file_data"]["curr_custs_aff"]["areas"][0]["areas"]
  end

  def coned_url_with_directory
    base_uri = "http://apps.coned.com"

    directory = HTTParty.get("#{base_uri}/stormcenter_external/stormcenter_externaldata/data/interval_generation_data/metadata.xml", :format => :xml).parsed_response['root']['directory']
    url = "#{base_uri}/stormcenter_external/stormcenter_externaldata/data/interval_generation_data/#{directory}/report.js"
  end
end
