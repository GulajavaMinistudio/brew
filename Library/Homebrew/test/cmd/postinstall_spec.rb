# typed: false
# frozen_string_literal: true

require "cmd/shared_examples/args_parse"

describe "Homebrew.postinstall_args" do
  it_behaves_like "parseable arguments"
end
