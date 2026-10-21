# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

- kettle-jem-template-20260720-005 - README Support & Community links now
  include RubyForum.
- kettle-jem-template-20260726-001 - Projects now include YARD lint
  configuration and documentation dependencies so documentation issues fail
  before generated docs are refreshed.
- kettle-jem-template-20260727-001 - Spec harness documentation now lists the
  RSpec helpers provided by `kettle-test`.

- kettle-jem-template-20260913-001 - Templating now also surfaces a review
  entry in `dependency_conflicts.resolve` when a direct development
  dependency doesn't support one or more of this project's declared
  `engines:` and has no template-managed modular home (e.g. `sqlite3` on
  `jruby`). Review each entry and pick a resolution per the project's own
  engine support needs.

### Changed

- Replaced stale Git-sourced development dependencies with released,
  template-managed dependency floors and refreshed the generated Kettle harness.

- kettle-jem-template-20260716-002 - Gemspecs now ship fewer repository-only
  files, reducing package noise for downstream packagers.
- kettle-jem-template-20260720-002 - Development Gemfiles now use the released
  `tree_sitter_language_pack` gem 1.13.3 or newer by default.
- kettle-jem-template-20260725-002 - Version specs now use `anonymous_loader` to
  cover `version.rb` without redefining constants, or are removed when version
  specs are not managed for the project.
- kettle-jem-template-20260728-001 - Generated Ruby workflows now use clearer
  setup-ruby-flash planning and can prepare appraisal-only jobs without
  installing the main Gemfile bundle.

- Document the Rails engine configuration and OpenID provider role in the README.

- kettle-jem-template-20260801-001 - Generated README gem dashboard links now
  use ClickGems instead of BestGems.

- [kc] kettle-jem/prepare: updated 17 project files:
  - configuration (1)
  - dependencies (16)

- [kc] kettle-jem/template: updated 5 project files:
  - dependencies (4)
  - other (1)

### Deprecated

### Removed

### Fixed

- Restricted stored post-login return URLs to relative or same-origin targets to
  prevent browser open redirects through `params[:return]` and
  `session[:return_to]`.

- Package configured license files in gem release file lists.

- kettle-jem-template-20260720-003 - StructuredMerge Git diff driver config now
  uses the installed `smorg-rb` driver command.
- kettle-jem-template-20260725-001 - Release pull request branches beginning
  with `feature/release` now run JRuby and TruffleRuby workflows.
- kettle-jem-template-20260726-002 - Generated version files now document their
  version namespace and constants, reducing warning-only YARD lint output.
- kettle-jem-template-20260726-003 - Coverage upload steps now treat Coveralls,
  QLTY, and Codecov as optional, so provider outages do not fail CI when local
  coverage thresholds still pass.
- kettle-jem-template-20260728-002 - Generated RuboCop configs now ignore the
  same `gemfiles/vendor/bundle` tree as `.gitignore`, so vendored dependency
  installs are not reported as project lint debt.
- kettle-jem-template-20260728-003 - Generated dep-heads workflows now run
  TruffleRuby jobs with current RubyGems and Bundler, avoiding setup failures
  before the test suite starts.
- kettle-jem-template-20260728-004 - Generated dep-heads workflows now use the
  setup-ruby Bundler install path for direct appraisal Gemfiles, avoiding rv
  lockfile parser failures on Git and path dependencies.
- kettle-jem-template-20260728-005 - VersionGem bootstrap now creates the
  missing canonical version spec when a project only has shim namespace version
  specs.
- kettle-jem-template-20260729-001 - Generated JRuby 9.4 workflows now use the
  legacy manual bundle install path, avoiding setup-time Bundler full-index
  failures against `gem.coop`.
- kettle-jem-template-20260730-001 - Gemspec package file enumeration now runs
  relative to the gemspec directory, so release package contents stay correct
  even when the gemspec is loaded from another working directory.

- kettle-jem-template-20260801-002 - Generated RSpec helpers now normalize
  managed configuration block bindings structurally, preventing mixed block
  parameter names from producing invalid configuration after a merge.
- kettle-jem-template-20260801-003 - Generated project metadata and
  documentation now normalize configured underscore hostnames to valid
  hyphenated hostnames.
- kettle-jem-template-20260801-004 - Generated organization README logos now
  use GitHub's stable organization avatar endpoint instead of assuming a
  matching Galtzo-hosted asset exists.
- kettle-jem-template-20260802-001 - Devcontainer JSON files now merge as JSONC,
  preserving comments and trailing commas during template updates.

### Security

## [1.0.0] - 2025-04-04

- TAG: [v1.0.0][1.0.0t]

- Line Coverage: 88.48% (776 / 877)
- Branch Coverage: 69.42% (193 / 278)
- 38.41% documented

### Added

- Compatibility with Rails v5.2, v6.x, 7.x, 8.0
- Compatibility with Ruby 2.7.8, 3.0, 3.1, 3.2, 3.3, 3.4, ruby-head

### Removed

- Dropped compatibility with Rails < 5.2
- Dropped compatibility with Ruby < 2.7.8

# masq releases

## [0.3.4]

* Always populate first and lastname when fullname is passed in
* Fix cancel_url request when checkid_request returns false

## [0.3.3]

* [Security] Updated Rails to version 3.2.22.2

## [0.3.2]

* Updated dependencies

## [0.3.1]

* Updated dependencies

## [0.3.0]

* Updated dependencies
* Patch on routing for email identifiers
* Internal improvements for testing

## V0.2.9

* Fork on gem to make ORACLE compatible fixes.

## [0.2.8]

* Updated dependencies

## [0.2.7]

* Updated dependencies, Gemfile.lock was not correct (crypt19 v1.2.1 does not exist anymore)

## [0.2.6]

* [Security] Updated Rails to version 3.2.12 and JSON to 1.7.7

## [0.2.5]

* [Security] Updated Rails to version 3.2.11

[Unreleased]: https://github.com/oauth-xx/masq2/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/oauth-xx/masq2/compare/bc6b6d84fe06811b9de19e7863c53c6bfad201fe...v1.0.0
[1.0.0t]: https://github.com/oauth-xx/masq2/tags/v1.0.0
