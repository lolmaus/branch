require './lib/branch'

Gem::Specification.new do |s|
  # Release Specific Information
  s.version = Branch::VERSION
  s.date = Branch::DATE

  # Gem Details
  s.name = "branch"
  s.description = "Run blocks asynchronously with little effort, a Ruby equivalent for JS setTimeout"
  s.summary = "This gem tries to reduce the amount of scaffolding required to be built manually in order to fire a couple of threads."
  s.authors = ["lolmaus (Andrey Mikhaylov)"]
  s.email = ["lolmaus@gmail.com"]
  s.homepage = "https://github.com/lolmaus/branch"
  s.licenses = ["MIT"]

  # Gem Files
  s.files = ["README.md"]
  s.files += ["CHANGELOG.md"]
  s.files += ["LICENSE.md"]
  s.files += Dir.glob("lib/**/*.*")

  # Gem Bookkeeping
  s.required_rubygems_version = ">= 1.3.6"
  s.rubygems_version = %q{1.3.6}
end
