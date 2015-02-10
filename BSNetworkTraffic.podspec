Pod::Spec.new do |s|
  s.name             	= "BSNetworkTraffic"
  s.version          	= "1.0.0"
  s.summary          	= "A singleton for calculating app's network traffic through system network counters."
  s.description      	= "A singleton for calculating system network traffic between calls of method 'resetCounters'. Thus you can get approximate values of app's sent/recieved data in bytes."
  s.homepage         	= "https://github.com/Bogdan-Stasjuk/BSNetworkTraffic"
  s.license      		= { :type => 'MIT', :file => 'LICENSE' }
  s.author           	= { "Bogdan Stasjuk" => "Bogdan.Stasjuk@gmail.com" }
  s.source           	= { :git => "https://github.com/Bogdan-Stasjuk/BSNetworkTraffic.git", :tag => '1.0.0' }
  s.social_media_url = 'https://twitter.com/Bogdan_Stasjuk'
  s.platform     		= :ios, '7.0'
  s.requires_arc 	= true
  s.source_files 	= 'BSNetworkTraffic/*.{h,m}'
  s.public_header_files   	= 'BSNetworkTraffic/*.h'
end
