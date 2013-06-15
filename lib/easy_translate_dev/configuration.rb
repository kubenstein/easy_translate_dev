module EasyTranslateDev
  class Configuration
    attr_accessor :google_user, :google_password, :google_spreadsheet_id, :logger

    def initialize
      self.google_user = ''
      self.google_password = ''
      self.google_spreadsheet_id = ''
      self.logger = Logger.new($stdout)
    end

  end
end
