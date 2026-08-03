require_relative "masq"
require "version_gem"
require_relative "masq/version"

Masq::Version.class_eval do
  extend VersionGem::Basic
end
