# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `simplecov_json_formatter` gem.
# Please instead update this file by running `bin/tapioca gem simplecov_json_formatter`.

# typed: true

module SimpleCov
  extend ::SimpleCov::Configuration

  class << self
    def at_exit_behavior; end
    def clear_result; end
    def collate(result_filenames, profile = T.unsafe(nil), ignore_timeout: T.unsafe(nil), &block); end
    def exit_and_report_previous_error(exit_status); end
    def exit_status_from_exception; end
    def external_at_exit; end
    def external_at_exit=(_arg0); end
    def external_at_exit?; end
    def filtered(files); end
    def final_result_process?; end
    def grouped(files); end
    def load_adapter(name); end
    def load_profile(name); end
    def pid; end
    def pid=(_arg0); end
    def previous_error?(error_exit_status); end
    def process_result(result); end
    def process_results_and_report_error; end
    def ready_to_process_results?; end
    def result; end
    def result?; end
    def result_exit_status(result); end
    def round_coverage(coverage); end
    def run_exit_tasks!; end
    def running; end
    def running=(_arg0); end
    def start(profile = T.unsafe(nil), &block); end
    def wait_for_other_processes; end
    def write_last_run(result); end

    private

    def adapt_coverage_result; end
    def add_not_loaded_files(result); end
    def initial_setup(profile, &block); end
    def lookup_corresponding_ruby_coverage_name(criterion); end
    def make_parallel_tests_available; end
    def probably_running_parallel_tests?; end
    def process_coverage_result; end
    def remove_useless_results; end
    def result_with_not_loaded_files; end
    def start_coverage_measurement; end
    def start_coverage_with_criteria; end
  end
end

module SimpleCov::Formatter
  class << self
    def from_env(env); end
  end
end

class SimpleCov::Formatter::JSONFormatter
  def format(result); end

  private

  def export_formatted_result(result_hash); end
  def format_result(result); end
  def output_message(result); end
end

SimpleCov::VERSION = T.let(T.unsafe(nil), String)
module SimpleCovJSONFormatter; end

class SimpleCovJSONFormatter::ResultExporter
  def initialize(result_hash); end

  def export; end

  private

  def export_path; end
  def json_result; end
end

SimpleCovJSONFormatter::ResultExporter::FILENAME = T.let(T.unsafe(nil), String)

class SimpleCovJSONFormatter::ResultHashFormatter
  def initialize(result); end

  def format; end

  private

  def format_source_file(source_file); end
  def formatted_result; end
end

class SimpleCovJSONFormatter::SourceFileFormatter
  def initialize(source_file); end

  def format; end

  private

  def branch_coverage; end
  def branches; end
  def line_coverage; end
  def lines; end
  def parse_branch(branch); end
  def parse_line(line); end
end
