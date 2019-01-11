Pod::Spec.new do |s|
    s.name        = "RealmHelpers"
    s.version     = "0.0.1"
    s.summary     = "RealmHelpers makes it easy to deal with Realm in Swift"
    s.homepage    = "https://github.com/AntonBelousov/RealmHelpers"
    s.license     = { :type => "MIT" }
    s.authors     = { "antbelousov" => "antbelousov@gmail.com" }

    s.requires_arc = true
    s.ios.deployment_target = "10.0"
    s.dependency 'RealmSwift'
    s.swift_version = '4.0'


    s.source   = { :git => "https://github.com/AntonBelousov/RealmHelpers.git", :tag => s.version }
    s.source_files = "Source/*.swift"
end
