require "version_gem"
require_relative "masq2/version"

require_relative "masq"

Masq2::Version.class_eval do
  extend VersionGem::Basic
end
