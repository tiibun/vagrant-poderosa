require 'pathname'
require 'rexml/document'
require 'tmpdir'

module VagrantPoderosa
  #
  class Shortcut
    def self.create_shortcut(vm, ssh_info)
      ssh_login_parameters = {
        'destination' => ssh_info[:host],
        'port' => ssh_info[:port],
        'account' => ssh_info[:username]
      }
      if ssh_info.include?(:password)
        ssh_login_parameters['authentication'] = 'Password'
        ssh_login_parameters['passphrase'] = ssh_info[:password]
      elsif ssh_info.include?(:private_key_path)
        ssh_login_parameters['authentication'] = 'PublicKey'
        # FIXME: multiple identity files
        ssh_login_parameters['identityFileName'] =
          absolute_winpath(ssh_info[:private_key_path][0], vm.env.root_path)
      end

      doc = REXML::Document.new
      doc << REXML::XMLDecl.new('1.0', 'UTF-8')
      root = doc.add_element('poderosa-shortcut', 'version' => '4.0')
      root.add_element('Poderosa.Terminal.TerminalSettings',
                       'encoding' => 'UTF8', 'caption' => ssh_info[:host])
      root.add_element('Poderosa.Protocols.SSHLoginParameter',
                       ssh_login_parameters)
      #        filename = Pathname(Dir.tmpdir) + (vm.name.to_s + '.gts')
      #      file = File.open(filename, 'wb')
      Tempfile.open(vm.name.to_s + '.gts') do |file|
        doc.write file
        file.close
        #      filename
        file.path
      end
    end

    def self.absolute_winpath(path, root_path)
      p = Pathname(path)
      return path.gsub(%r{\/}, '\\') if p.absolute?
      Pathname(root_path).join(p).to_s.gsub(%r{\/}, '\\')
    end
  end
end
