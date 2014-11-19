#In summary:

# config/initializers/load_config.rb
#APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

# application.rb
#if APP_CONFIG['perform_authentication']
  # Do stuff
#end

require 'delegate'

class AppConfig < SimpleDelegator
  def initialize(file_name)
    #super(symbolize_keys( YAML.load_file(file_name)[Rails.env] || YAML.load_file(file_name)))
    super( YAML.load_file(file_name)[Rails.env] || YAML.load_file(file_name))
  end

  def [](*path)
    path.inject(__getobj__()) {|config, item|
      item = item.to_s
      config[item]
    }
  end

  #def author_open_ids
  #  [self[:author, :open_id]].flatten.map {|uri| URI.parse(uri)}
  #end

  def self.default
    AppConfig.new(default_location)
  end

  def self.default_location
    "#{Rails.root}/config/oauth_provider_demo.yml"
  end


  private

  def symbolize_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value.is_a?(Hash) ? symbolize_keys(value) : value
      options
    end
  end
end
