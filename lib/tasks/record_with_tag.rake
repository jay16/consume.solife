namespace :rwt do
  task :build => :environment do
    current_user=User.find_by(id: 1)
    current_user.records.each do |record|
      current_user.tags.each do |tag|
        record.tags << tag
        puts record.tags.count
        record.save
      end
      puts record.tags.count
    end
  end

  task :force => :environment do
    current_user=User.find_by(id: 1)
    current_user.records.each do |record|
      current_user.tags.each do |tag|
        RecordWithTag.create({:record_id => record.id, :tag_id => tag.id})
        puts record.tags.count
      end
      puts record.tags.count
    end
  end
end
