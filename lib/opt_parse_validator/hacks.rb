class OptionParser
  # Hack to suppress the completion (expect for the -h/--help) which was leading to
  # unwanted behaviours
  # See https://github.com/wpscanteam/CMSScanner/issues/2
  module Completion
    class << self
      alias_method :original_candidate, :candidate

      def candidate(key, icase = false, pat = nil, &block)
        # Maybe also do this for -v/--version ?
        key == 'h' ? original_candidate('help', icase, pat, &block) : []
      end
    end
  end
end
