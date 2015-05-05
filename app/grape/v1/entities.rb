module APIEntities

  class User < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :name, :email
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end
  class UserReport < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :maximum_per_one, :maximum_per_day, 
           :summary_by_day, :summary_by_week, :summary_by_month, :summary_by_year, :summary_by_all
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

  class Record < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :user_id,  #user id
           :id,       #record id
           :value,    #consume value
           :remark,   #consume value
           :ymdhms,   #consume timestamp
           :klass,    #consume klass
           :tags_list, #consume tags list
           :deleted
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

  class DeletedRecord < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }
    expose :user_id,  #user id
           :id,       #record id
           :klass,    #consume klass
           :deleted
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

  class Tag < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :user_id, :id, :label, :klass, :deleted
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

  class DeletedTag < Grape::Entity
    expose :user_id, :id, :klass, :deleted
  end
end
