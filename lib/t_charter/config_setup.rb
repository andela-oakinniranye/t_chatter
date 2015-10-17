module TCharter
  class ConfigSetup
    include Singleton

    CONFIG_FILE = '.chatter.yml'
    CONFIG_FILE_SOURCES = ['.', '..', ENV["HOME"]]

    def self.set_configuration
      config_file = nil
      CONFIG_FILE_SOURCES.each{ |file_source|
          config_file = "#{file_source}/#{CONFIG_FILE}"
          break if File.exists? config_file
      }
      @@config_data = load_config(config_file) if config_file
    end

    def self.load_config(file_path)
      ::YAML.load_file(file_path)
    end

    def configuration
      @@config_data
    end

    set_configuration
  end

end
