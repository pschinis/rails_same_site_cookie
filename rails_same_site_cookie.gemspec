lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_same_site_cookie/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_same_site_cookie"
  spec.version       = RailsSameSiteCookie::VERSION
  spec.authors       = ["Philip Schinis"]
  spec.email         = ["p.schinis@gmail.com"]

  spec.summary       = %q{This gem allows you to set the SameSite=None cookie directive without breaking browsers that don't support it.}
  spec.homepage      = "https://github.com/pschinis/rails_same_site_cookie"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pschinis/rails_same_site_cookie"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "rack", ">= 1.5"
  spec.add_dependency "user_agent_parser", "~> 2.5"
end
