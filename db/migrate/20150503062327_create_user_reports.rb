class CreateUserReports < ActiveRecord::Migration
  def change
    create_table :user_reports do |t|
      t.belongs_to :user
      t.float :maximum_per_one
      t.float :maximum_per_day
      t.float :summary_by_day
      t.float :summary_by_week
      t.float :summary_by_month
      t.float :summary_by_year
      t.float :summary_by_all

      t.timestamps
    end
  end
end
