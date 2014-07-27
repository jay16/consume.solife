class Cpanel::HomeController < Cpanel::ApplicationController
  def index
    @recent_records = Record.recent.limit(10)
  end
end
