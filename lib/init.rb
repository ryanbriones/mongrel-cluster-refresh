require 'rubygems'
require 'gem_plugin'
require 'mongrel'
require 'yaml'

module Cluster
  class Refresh < GemPlugin::Plugin '/commands'
    include Mongrel::Command::Base

    def configure
      options [
               ['-C', '--config PATH', 'Path to cluster configuration file', :@config_file, "config/mongrel_cluster.yml"],
               ['-R', '--refresh NUM', 'Number of mongrels to refresh', :@refresh_num, nil],
               ['', '--clean', "Remove orphaned pid files", :@clean, false],
              ]
    end

    def validate
      valid_exists?(@config_file, "Configuration file does not exist")
      @valid
    end
    
    def run
      read_config
      collect_mongrel_stats
      refresh
    end

    def read_config
      @options = {
        "port" => 3000,
        "pid_file" => "tmp/pids/mongrel.pid",
        "servers" => 2
      }

      conf = YAML.load_file(@config_file)
      @options.merge!(conf) if conf

      third_of_servers = @options["servers"].to_i/3
      @refresh_num ||= (third_of_servers.zero? ? 1 : third_of_servers)
    end

    def collect_mongrel_stats
      start_port = @options["port"].to_i
      end_port = start_port + @options["servers"].to_i - 1
      
      mongrel_instance_base = {
        :port => nil,
        :pid => nil,
        :cpu => nil,
        :mem => nil
      }
      
      @mongrels = (start_port..end_port).inject([]) do |mongrels, port|
        mongrel = mongrel_instance_base.dup
        begin
          mongrel[:port] = port
          mongrel[:pid] = File.read(port_pid_file(port)).strip.to_i
          
          process_string = `ps -p #{mongrel[:pid]} -o pcpu= -o pmem=`

          if(process_string.nil? || process_string.strip == "")
            if @clean
              File.unlink(port_pid_file(port))
              puts "missing process: removing #{port_pid_file(port)}"
            end
            
            next(mongrels)
          end

          cpu, mem = process_string.split(" ").map { |field| field.strip }
          
          mongrel[:cpu] = cpu.to_f
          mongrel[:mem] = mem.to_f

          mongrels << mongrel
        ensure
          mongrels
        end
      end

      @mongrels = @mongrels.sort_by { |mongrel| [-mongrel[:mem], -mongrel[:cpu], mongrel[:pid]] }
    end

    def refresh
      @mongrels.first(@refresh_num).each do |mongrel|
        puts "restarting mongrel on port #{mongrel[:port]}"
        Process.kill("USR2", mongrel[:pid])
      end
    end

    def port_pid_file(port)
      pid_file_ext = File.extname(@options["pid_file"])
      pid_file_base = File.basename(@options["pid_file"], pid_file_ext)

      path = []
      path << @options["cwd"] if @options["cwd"]
      path << File.dirname(@options["pid_file"])
      pid_file_dir = File.join(path)
      
      pid_file = [pid_file_base, port].join(".") + pid_file_ext
      File.join(pid_file_dir, pid_file)
    end
  end
end
