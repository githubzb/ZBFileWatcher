Pod::Spec.new do |s|
  s.name         = "ZBFileWatcher"
  s.version      = "0.0.1"
  s.summary      = "The file watcher class."
  s.description  = <<-DESC
                    This is a file watcher, and you can watch the file change.
                   DESC
  s.homepage     = "https://github.com/githubzb/ZBFileWatcher"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "dr.box" => "1126976340@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/githubzb/ZBFileWatcher.git", :tag => "#{s.version}" }
  s.source_files = "fileWatcher/class/**/*.{h,m}"
  s.requires_arc = true
  
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
