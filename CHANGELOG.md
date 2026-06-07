# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

Since version 1.0, the format is based on [Keep a Changelog][📗keep-changelog],
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
### Changed
### Fixed
- Restricted stored post-login return URLs to relative or same-origin targets to
  prevent browser open redirects through `params[:return]` and
  `session[:return_to]`.
### Removed

## [1.0.0] - 2025-04-04 ([tag][1.0.0t])
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

## v0.3.4

* Always populate first and lastname when fullname is passed in
* Fix cancel_url request when checkid_request returns false

## v0.3.3

* [Security] Updated Rails to version 3.2.22.2

## v0.3.2

* Updated dependencies

## v0.3.1

* Updated dependencies

## v0.3.0

* Updated dependencies
* Patch on routing for email identifiers
* Internal improvements for testing

## V0.2.9

* Fork on gem to make ORACLE compatible fixes.

## v0.2.8

* Updated dependencies

## v0.2.7

* Updated dependencies, Gemfile.lock was not correct (crypt19 v1.2.1 does not exist anymore)

## v0.2.6

* [Security] Updated Rails to version 3.2.12 and JSON to 1.7.7

## v0.2.5

* [Security] Updated Rails to version 3.2.11

[Unreleased]: https://github.com/oauth-xx/masq2/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/oauth-xx/masq2/compare/bc6b6d84fe06811b9de19e7863c53c6bfad201fe...v1.0.0
[1.0.0t]: https://github.com/oauth-xx/masq2/tags/v1.0.0
