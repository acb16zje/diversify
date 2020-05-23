# frozen_string_literal: true

require 'oj'
require_relative '../../spec/simplecov_env'
SimpleCovEnv.configure_profile

module SimpleCov
  module ResultMerger
    def self.merge_all_results!
      resultset_files = Pathname.glob(
        File.join(SimpleCov.coverage_path, '**', '.resultset.json')
      )

      result_array = begin
                       resultset_files.map do |result_file|
                         SimpleCov::Result.from_hash Oj.load(result_file.read)
                       end
                     rescue StandardError
                       {}
                     end
      SimpleCov::ResultMerger.merge_results(*result_array).format!
    end
  end
end

SimpleCov::ResultMerger.merge_all_results!
