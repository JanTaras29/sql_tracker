require 'active_support/configurable'

module SqlTracker
  class Config
    include ActiveSupport::Configurable
    config_accessor :tracked_paths, :tracked_sql_command, :output_path, :enabled, :ignore_cache

    class << self
      def apply_defaults
        self.enabled = enabled.nil? ? true : enabled
        self.tracked_paths ||= %w(app lib)
        self.tracked_sql_command ||= %w(SELECT INSERT UPDATE DELETE)
        # Ignore queries called from ActiveRecord's SQL Cahce
        self.ignore_cache ||= false
        self.output_path ||= begin
          if defined?(::Rails) && ::Rails.root
            File.join(::Rails.root.to_s, 'tmp')
          else
            'tmp'
          end
        end
        self
      end
    end
  end
end
