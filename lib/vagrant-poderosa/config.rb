module VagrantPoderosa
  class Config < Vagrant.plugin(2, :config)
    # Program file absolute path or command name if found in PATH.
    # If value is undefined, search
    #   poderosa.exe
    #
    # @return [String]
    attr_accessor :exe_path

    def initialize
      @exe_path = UNSET_VALUE
    end

    def finalize!
      @exe_path = nil if @exe_path == UNSET_VALUE
    end
  end
end
