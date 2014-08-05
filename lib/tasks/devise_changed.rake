#encoding: utf-8
namespace :devise do  
  desc "devise password changed"
  task :changed => [:environment] do
    list = {
      "jay_li@solife.us" => "jay527130673"
    }
    list.each_pair do |k, v|
      user = User.find_by(email: k)
      raise "user is nil, #{k}, #{v}" if user.nil?
      user.update_column(:encrypted_password, Utils::Encryptor.encode(v)) 
    end
  end
end
