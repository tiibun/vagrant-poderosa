require 'optparse'
require 'pathname'

module VagrantPoderosa
  #
  class Command < Vagrant.plugin(2, :command)
    def self.synopsis
      'connects to machine via SSH using Poderosa'
    end

    def execute
      opts = OptionParser.new do |opt|
        opt.banner = 'Usage: vagrant poderosa [vm-name...]'

        opt.separator ''
      end

      argv = parse_options(opts)
      return -1 unless argv

      with_target_vms(argv, single_target: true) do |vm|
        @config = vm.config.poderosa

        ssh_info = vm.ssh_info
        @logger.debug("ssh_info is #{ssh_info}")
        # If ssh_info is nil, the machine is not ready for ssh.
        fail Vagrant::Errors::SSHNotReady if ssh_info.nil?

        exe_path = find_exe_path(@config.exe_path)
        return -1 unless exe_path

        commands = [
          "\"#{exe_path}\"",
          '-open',
          create_shortcut(vm, ssh_info)
        ]
        do_process(commands)
      end
    end

    def find_exe_path(path)
      if !path.nil?
        return path if File.executable?(path)

        # search in PATH
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |p|
          exe_path = Pathname(p) + path
          return exe_path.to_s if exe_path.executable?
        end
      else
        # search in PATH
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |p|
          exe_path = Pathname(p) + 'Poderosa.exe'
          return exe_path.to_s if exe_path.executable?
        end
      end

      @env.ui.error("File is not found or executable. => #{path}")
      nil
    end

    def create_shortcut(vm, ssh_info)
      require_relative 'shortcut'
      Shortcut.create_shortcut(vm, ssh_info)
    end

    def do_process(commands)
      pid = spawn(commands.join(' '))
      Process.detach(pid)
    end
  end
end
