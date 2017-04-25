#:  * `search`, `-S`:
#:    Display all locally available formulae for brewing (including tapped ones).
#:    No online search is performed if called without arguments.
#:
#:  * `search` [`--desc`] (<text>|`/`<text>`/`):
#:    Perform a substring search of formula names for <text>. If <text> is
#:    surrounded with slashes, then it is interpreted as a regular expression.
#:    The search for <text> is extended online to some popular taps.
#:
#:    If `--desc` is passed, browse available packages matching <text> including a
#:    description for each.
#:
#:  * `search` (`--debian`|`--fedora`|`--fink`|`--macports`|`--opensuse`|`--ubuntu`) <text>:
#:    Search for <text> in the given package manager's list.

require "formula"
require "missing_formula"
require "utils"
require "official_taps"
require "descriptions"

module Homebrew
  module_function

  def search
    if ARGV.empty?
      puts Formatter.columns(Formula.full_names)
    elsif ARGV.include? "--macports"
      exec_browser "https://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? "--fink"
      exec_browser "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.include? "--debian"
      exec_browser "https://packages.debian.org/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.include? "--opensuse"
      exec_browser "https://software.opensuse.org/search?q=#{ARGV.next}"
    elsif ARGV.include? "--fedora"
      exec_browser "https://admin.fedoraproject.org/pkgdb/packages/%2A#{ARGV.next}%2A/"
    elsif ARGV.include? "--ubuntu"
      exec_browser "http://packages.ubuntu.com/search?keywords=#{ARGV.next}&searchon=names&suite=all&section=all"
    elsif ARGV.include? "--desc"
      query = ARGV.next
      regex = query_regexp(query)
      Descriptions.search(regex, :desc).print
    elsif ARGV.first =~ HOMEBREW_TAP_FORMULA_REGEX
      query = ARGV.first
      user, repo, name = query.split("/", 3)

      begin
        result = Formulary.factory(query).name
      rescue FormulaUnavailableError
        result = search_tap(user, repo, name)
      end

      results = Array(result)
      puts Formatter.columns(results) unless results.empty?
    else
      query = ARGV.first
      regex = query_regexp(query)
      local_results = search_formulae(regex)
      puts Formatter.columns(local_results) unless local_results.empty?
      tap_results = search_taps(query)
      puts Formatter.columns(tap_results) if tap_results && !tap_results.empty?

      if $stdout.tty?
        count = local_results.length + tap_results.length

        if reason = Homebrew::MissingFormula.reason(query, silent: true)
          if count > 0
            puts
            puts "If you meant #{query.inspect} specifically:"
          end
          puts reason
        elsif count.zero?
          puts "No formula found for #{query.inspect}."
          GitHub.print_pull_requests_matching(query)
        end
      end
    end

    return unless $stdout.tty?
    return if ARGV.empty?
    metacharacters = %w[\\ | ( ) [ ] { } ^ $ * + ?].freeze
    return unless metacharacters.any? do |char|
      ARGV.any? do |arg|
        arg.include?(char) && !arg.start_with?("/")
      end
    end
    ohai <<-EOS.undent
      Did you mean to perform a regular expression search?
      Surround your query with /slashes/ to search locally by regex.
    EOS
  end

  def query_regexp(query)
    case query
    when %r{^/(.*)/$} then Regexp.new($1)
    else /.*#{Regexp.escape(query)}.*/i
    end
  rescue RegexpError
    odie "#{query} is not a valid regex"
  end

  def search_taps(query)
    valid_dirnames = ["Formula", "HomebrewFormula", "Casks", ".", ""].freeze
    q = "user:Homebrew%20user:caskroom%20filename:#{query}"
    GitHub.open "https://api.github.com/search/code?q=#{q}" do |json|
      json["items"].map do |object|
        dirname, filename = File.split(object["path"])
        next unless valid_dirnames.include?(dirname)
        user = object["repository"]["owner"]["login"]
        user = user.downcase if user == "Homebrew"
        repo = object["repository"]["name"].sub(/^homebrew-/, "")
        tap = Tap.fetch user, repo
        next if tap.installed?
        basename = File.basename(filename, ".rb")
        "#{user}/#{repo}/#{basename}"
      end.compact
    end
  end

  def search_formulae(regex)
    aliases = Formula.alias_full_names
    results = (Formula.full_names+aliases).grep(regex).sort

    results.map do |name|
      begin
        formula = Formulary.factory(name)
        canonical_name = formula.name
        canonical_full_name = formula.full_name
      rescue
        canonical_name = canonical_full_name = name
      end

      # Ignore aliases from results when the full name was also found
      next if aliases.include?(name) && results.include?(canonical_full_name)

      if (HOMEBREW_CELLAR/canonical_name).directory?
        pretty_installed(name)
      else
        name
      end
    end.compact
  end
end
