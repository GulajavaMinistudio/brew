# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `Homebrew::DevCmd::GenerateCaskApi`.
# Please instead update this file by running `bin/tapioca dsl Homebrew::DevCmd::GenerateCaskApi`.

class Homebrew::DevCmd::GenerateCaskApi
  sig { returns(Homebrew::DevCmd::GenerateCaskApi::Args) }
  def args; end
end

class Homebrew::DevCmd::GenerateCaskApi::Args < Homebrew::CLI::Args
  sig { returns(T::Boolean) }
  def dry_run?; end

  sig { returns(T::Boolean) }
  def n?; end
end
