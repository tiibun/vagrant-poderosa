# Vagrant Poderosa Plugin

This is a Vagrant plugin that enables to ssh into vm with Poderosa.

## Installation

```
vagrant plugin install vagrant-poderosa
```

## Usage

```
vagrant poderosa [vm-name]
```

## Configuration

```ruby
Vagrant.configure(2) do |config|
  # ...
  config.poderosa.exe_path = '[path to poderosa]/poderosa.exe'
  # ...
end
```

* ```exe_path``` A poderosa.exe file path. We will find real path
  * If set and executable, use it.
  * If set and not executable, search in PATH.
  * If not set, search "poderosa.exe" in PATH.

## Contributing

1. Fork it ( https://github.com/tiibun/vagrant-poderosa/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Thanks

Vagrant ( https://github.com/https://github.com/mitchellh/vagrant )
vagrant-multi-putty ( https://github.com/nickryand/vagrant-multi-putty )
