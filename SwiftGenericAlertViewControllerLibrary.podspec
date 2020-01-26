Pod::Spec.new do |spec|

  spec.name         = "SwiftGenericAlertViewControllerLibrary"
  spec.version      = "1.0.0"
  spec.summary      = "GenericPopover is a custom alertViewController with tableView and input mode."

  spec.description  = " GenericPopover have Base class with template and contentview.
  PopOver base class has a header card color, title and SubTitle text which are public variable. 
  ContentView can be customised with table, textView or image and buttons"

  spec.homepage     = "https://github.com/shruezee/SwiftGenericAlertViewController"
  spec.license      = "MIT"
  spec.author       = { "shruthi" => "shruthi.palchandar@gmail.com" }

  spec.source       = { :git => "https://github.com/shruezee/SwiftGenericAlertViewController.git", :tag => "#{spec.version}" }
  spec.source_files  = "SwiftGenericAlertViewController"
  spec.exclude_files = "Classes/Exclude"
  s.swift_version = "5.2" 

end
