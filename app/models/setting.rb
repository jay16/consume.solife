class Setting < Settingslogic
  source "#{Rails.root}/config/config.yaml"
  namespace Rails.env
  #load! if Rails.env.development?
end
