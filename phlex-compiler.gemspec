# frozen_string_literal: true

Gem::Specification.new do |spec|
	spec.name = "phlex-compiler"
	spec.version = "0.0.1"
	spec.authors = ["Joel Drapper"]
	spec.email = ["joel@drapper.me"]

	spec.summary = "A compiler for Phlex"
	spec.description = "A compiler for Phlex"
	spec.homepage = "https://github.com/joeldrapper/phlex-compiler"
	spec.license = "MIT"
	spec.required_ruby_version = ">= 2.7"

	spec.metadata["homepage_uri"] = spec.homepage
	spec.metadata["source_code_uri"] = "https://github.com/joeldrapper/phlex-compiler"
	spec.metadata["changelog_uri"] = "https://github.com/joeldrapper/phlex-compiler/releases"
	spec.metadata["funding_uri"] = "https://github.com/sponsors/joeldrapper"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(File.expand_path(__dir__)) do
		`git ls-files -z`.split("\x0").reject do |f|
			(f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
		end
	end
	spec.bindir = "exe"
	spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency "phlex", "~> 1.0"
	spec.add_dependency "syntax_tree", "~> 3.6"

	spec.metadata["rubygems_mfa_required"] = "true"
end
