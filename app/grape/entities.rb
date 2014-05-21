module APIEntities

  class User < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :id, :name, :email
    with_options(format_with: :ymdhms_format) do
      expose :created_at
    end
  end

  class Record < Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :user_id,  #user id
           :id,       #record id
           :value,    #consume value
           :ymdhms,   #consume timestamp
           :klass,    #consume klass
           :tags_list #consume tags list
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

  class Tag< Grape::Entity
    format_with(:ymdhms_format) { |t| t.strftime("%Y-%m-%d %H:%M:%S") }

    expose :user_id, :id, :label, :klass
    with_options(format_with: :ymdhms_format) do
      expose :created_at
      expose :updated_at
    end
  end

end
