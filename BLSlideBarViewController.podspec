Pod::Spec.new do |s|


s.name         = "BLSlideBarViewController"
s.version      = "1.2"
s.summary      = "多个视图间的滑动切换效果，能够自动调整视图类别标题的可视范围，并可以定制标题颜色、字体大小以及可选扩展功能菜单，简单易用！"

s.homepage     = "https://github.com/busylife1987/BLSlideBarViewController"

s.license      = "MIT"

s.author       = { "busylife1987" => "busylife1987@126.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/busylife1987/BLSlideBarViewController.git", :tag => "1.2"}

s.source_files  = "BLSlideBar/*"

s.requires_arc = true

end
