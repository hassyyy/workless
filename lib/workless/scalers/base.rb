# frozen_string_literal: true

require 'delayed_job'

module Delayed
  module Workless
    module Scaler
      class Base
        def self.jobs
          Delayed::Job.where(failed_at: nil)
        end
      end

      module HerokuClient
        def client
          @client ||= ::PlatformAPI.connect(ENV['WORKLESS_API_KEY'])
        end
      end

      module UptimeRobotClient
        def uptime_robot_client
          @uptime_robot_client = UptimeRobot::Client.new(api_key: ENV['UPTIME_ROBOT_API_KEY'])
        end

        def find_monitor(monitor_name)
          monitors = uptime_robot_client.getMonitors['monitors']
          result = monitors.detect {|monitor| monitor['friendly_name'] == monitor_name }
          raise "Monitor: #{monitor_name} not found" if result.nil?
          return result
        end

        def resume_monitor(monitor_name)
          uptime_robot_client.editMonitor(id: find_monitor(monitor_name)['id'], status: 1)
        end

        def pause_monitor(monitor_name)
          uptime_robot_client.editMonitor(id: find_monitor(monitor_name)['id'], status: 0)
        end
      end
    end
  end
end
