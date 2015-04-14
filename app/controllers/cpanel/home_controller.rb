class Cpanel::HomeController < Cpanel::ApplicationController
  def index
    @recent_records = Record.recent.limit(10)
  end

  # report files list
  def reports
    @reports = Dir.glob(Rails.root.join("log/report/*.html"))
      .map { |file| [file, file.scan(/.*?report\.(\d{6})_(\d{6})\.html/)].flatten }
  end

  # show report
  def report
    filepath = Rails.root.join("log/report/", "report.%s.html" % params[:timestamp])
    render file: filepath, layout: false
  end
end
