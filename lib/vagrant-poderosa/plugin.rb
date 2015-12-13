require "vagrant"

module VagrantPoderosa
  class Plugin < Vagrant.plugin("2")
    name "Poderosa Plugin"
    description <<-DESC
    This plugin enables to ssh into vm using Poderosa.
    DESC

    command "poderosa" do
      require_relative "command"
      Command
    end

    config "poderosa" do
      require_relative "config"
      Config
    end
  end
end
