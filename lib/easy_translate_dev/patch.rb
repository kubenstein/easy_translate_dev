require 'google_drive'

module EasyTranslateDev
  module Patch
    def translate(text, options = {}, http_options = {})
      puts "using EasyTranslateDev"
      translate_from = (options[:from] || 'en').to_s
      translate_to = options[:to].to_s
      return text if translate_to == translate_from

      spreadsheet[2, 1] = '=GoogleTranslate(B2; "'+ translate_from +'"; "'+ translate_to +'")'
      spreadsheet[2, 2] = text

      spreadsheet.synchronize
      spreadsheet[2, 1]
    end

    def session
      @easy_translate_dev_session ||= GoogleDrive.login(EasyTranslateDev.configuration.google_user, EasyTranslateDev.configuration.google_password)
    end

    def spreadsheet
      @easy_translate_dev_spreadsheet ||= session.spreadsheet_by_key(EasyTranslateDev.configuration.google_spreadsheet_id).worksheets[0]
    end

  end
end
