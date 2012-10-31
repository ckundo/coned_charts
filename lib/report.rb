require 'google_drive'

class Report
  SPREADSHEET_TITLE = "Hurricane Sandy ConEd Outages"
  WORKSHEET_TITLE = "Sheet1"
  
  def initialize
    @session = GoogleDrive.login(ENV["GOOGLE_USER"], ENV["GOOGLE_PASSWORD"])
    @spreadsheet ||= @session.spreadsheet_by_title(SPREADSHEET_TITLE)
  end

  def update_worksheet(outage_row)
    worksheet = @spreadsheet.worksheet_by_title(WORKSHEET_TITLE)
    first_available_row = worksheet.num_rows + 1
    worksheet.update_cells(first_available_row, 1, [outage_row])
    worksheet.synchronize
  end
end
