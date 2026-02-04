Pod::Spec.new do |s|
  s.name             = 'WidgetDevelopmentKit'
  s.version          = '1.0.0'
  s.summary          = 'The complete toolkit for building beautiful iOS widgets with WidgetKit, Live Activities, and Dynamic Island.'
  s.description      = <<-DESC
    WidgetDevelopmentKit provides everything you need to build stunning iOS widgets.
    Features include Home Screen Widgets, Lock Screen Widgets, Live Activities,
    StandBy Mode support, Interactive Widgets with App Intents, and 20+ pre-built
    templates. Build beautiful widgets in minutes, not days.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/iOS-Widget-Development-Kit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/iOS-Widget-Development-Kit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/muhittincamdali'

  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'
  s.tvos.deployment_target = '16.0'
  s.watchos.deployment_target = '9.0'

  s.swift_versions = ['5.9', '5.10', '6.0']

  s.source_files = 'Sources/**/*.swift'

  s.frameworks = 'Foundation', 'SwiftUI', 'WidgetKit'

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/Core/**/*.swift'
  end

  s.subspec 'Security' do |security|
    security.source_files = 'Sources/Security/**/*.swift'
    security.dependency 'WidgetDevelopmentKit/Core'
  end

  s.subspec 'Performance' do |performance|
    performance.source_files = 'Sources/Performance/**/*.swift'
    performance.dependency 'WidgetDevelopmentKit/Core'
  end

  s.subspec 'Enterprise' do |enterprise|
    enterprise.source_files = 'Sources/Enterprise/**/*.swift'
    enterprise.dependency 'WidgetDevelopmentKit/Core'
    enterprise.dependency 'WidgetDevelopmentKit/Security'
  end

  s.subspec 'Integration' do |integration|
    integration.source_files = 'Sources/Integration/**/*.swift'
    integration.dependency 'WidgetDevelopmentKit/Core'
  end
end
