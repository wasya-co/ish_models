
require 'net/scp'
require 'open3'
require 'droplet_kit'

class WcoHosting::Runner

  def self.create_ecs_task
  end

  TASK_REDEPLOY_ECS_TASK_DEFINITION = 'redeploy-ecs-task-definition'
  TASK_REDEPLOY_ECS_TASK            = 'redeploy-ecs-task'
  TASKS = []

  def self.do_exec cmd
    Wco::Log.puts! cmd, '#do_exec', obj: @obj

    stdout, stderr, status = Open3.capture3(cmd)
    status = status.to_s.split.last.to_i
    Wco::Log.puts! stdout, 'stdout', obj: @obj
    Wco::Log.puts! stderr, 'stderr', obj: @obj
    Wco::Log.puts! status, 'status', obj: @obj
    return { stdout: stdout, stderr: stderr, status: status }
  end

end
