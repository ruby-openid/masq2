# frozen_string_literal: true

# kettle-jem:freeze
# To retain chunks of comments & code during kettle-jem templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# kettle-jem will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

source "https://gem.coop"

git_source(:codeberg) { |repo_name| "https://codeberg.org/#{repo_name}" }
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

#### IMPORTANT #######################################################
# Gemfile is for local development ONLY; Gemfile is NOT loaded in CI #
####################################################### IMPORTANT ####

# Load order it important for combustion, so make sure it loads first!
gem "combustion", "~> 1.5"

# Include dependencies from masq2.gemspec
gemspec

# Local workspace dependency wiring for *_local.gemfile overrides
gem "nomono", "~> 1.0", ">= 1.0.4", require: false # ruby >= 2.2

# Templating (env-switched: SMORG_RB_DEV=/path/to/structuredmerge/ruby/gems for local paths)
eval_gemfile "gemfiles/modular/templating.gemfile" if ENV.fetch("K_JEM_TEMPLATING", "false").casecmp("true").zero?

# Security Audit
eval_gemfile "gemfiles/modular/audit.gemfile"

# Debugging
eval_gemfile "gemfiles/modular/debug.gemfile"

# Code Coverage (env-switched: KETTLE_RB_DEV=true for local paths)
eval_gemfile "gemfiles/modular/coverage.gemfile"

# Linting
eval_gemfile "gemfiles/modular/style.gemfile"

# Documentation
eval_gemfile "gemfiles/modular/documentation.gemfile"

# Optional
eval_gemfile "gemfiles/modular/optional.gemfile"

### Std Lib Extracted Gems
eval_gemfile "gemfiles/modular/x_std_libs.gemfile"

# See unlocked_deps appraisal for more details on irb inclusion
gem "irb", "~> 1.17" # ruby >= 2.7
# DB Adapters
eval_gemfile "gemfiles/modular/db_adapters.gemfile"

# Testing
eval_gemfile "gemfiles/modular/mini_testing.gemfile"

# Local Testing (not applicable to CI)
# gem "guard-minitest"

gem "appraisal2", "~> 3.1", ">= 3.1.2"

# For local testing we'll use Rails v8.0
# In CI we'll use `combustion` and `appraisal2` to test other versions
gem "rails", "~> 8.0", ">= 8.0.2"
