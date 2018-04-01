# frozen_string_literal: true

require 'platform-api'
require 'uptimerobot'

module Delayed
  module Workless
    module Scaler
      class Heroku < Base
        extend Delayed::Workless::Scaler::HerokuClient
        extend Delayed::Workless::Scaler::UptimeRobotClient

        def self.up
          return unless workers_needed > min_workers && workers < workers_needed
          updates = { "quantity": workers_needed }
          client.formation.update(ENV['APP_NAME'], 'worker', updates)
          resume_monitor(ENV['APP_NAME'])
        end

        def self.down
          return if workers == workers_needed
          updates = { "quantity": workers_needed }
          client.formation.update(ENV['APP_NAME'], 'worker', updates)
          pause_monitor(ENV['APP_NAME']) if workers.zero?
        end

        def self.workers
          client.formation.info(ENV['APP_NAME'], 'worker')['quantity'].to_i
        end

        # Returns the number of workers needed based on the current number of pending jobs and the settings defined by:
        #
        # ENV['WORKLESS_WORKERS_RATIO']
        # ENV['WORKLESS_MAX_WORKERS']
        # ENV['WORKLESS_MIN_WORKERS']
        #
        def self.workers_needed
          [[(jobs.count.to_f / workers_ratio).ceil, max_workers].min, min_workers].max
        end

        def self.workers_ratio
          if ENV['WORKLESS_WORKERS_RATIO'].present? && (ENV['WORKLESS_WORKERS_RATIO'].to_i != 0)
            ENV['WORKLESS_WORKERS_RATIO'].to_i
          else
            100
          end
        end

        def self.max_workers
          ENV['WORKLESS_MAX_WORKERS'].present? ? ENV['WORKLESS_MAX_WORKERS'].to_i : 1
        end

        def self.min_workers
          ENV['WORKLESS_MIN_WORKERS'].present? ? ENV['WORKLESS_MIN_WORKERS'].to_i : 0
        end
      end
    end
  end
end
