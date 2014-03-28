class HomeController < ApplicationController
  def index
    @records = current_user.records
    @record = current_user.records.new
<<<<<<< HEAD
    @record.ymdhms = Time.now.strftime("%Y-%m-%d %H:%M:%S")
=======
>>>>>>> d912a81dcb184f299cd83b00b40589470505e6c8
  end
end
