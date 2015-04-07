#encoding: utf-8
require "fileutils"
namespace :assets do
  desc "customize rake assets:precompile"
  task :my_precompile => [:environment] do
    Rake::Task["assets:precompile"].invoke
    fonts_path  = Rails.root.join("app/assets/fonts")
    assets_path = Rails.root.join("public/assets/fonts") 
    FileUtils.mkdir_p(assets_path) unless File.exist?(assets_path)
    system("cp %s/* %s" % [fonts_path, assets_path])
  end
end
