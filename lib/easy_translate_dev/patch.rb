require 'google_drive'

module EasyTranslateDev
  module Patch
    def translate(input, options = {}, http_options = {})
      translate_from = (options[:from] || 'en').to_s
      translate_to = options[:to].to_s
      return text if translate_to == translate_from

      return translate_hash(input, translate_from, translate_to) if input.is_a?(Hash)
      return translate_array(input, translate_from, translate_to) if input.is_a?(Array)
      return translate_text(input, translate_from, translate_to) if input.is_a?(String)
      raise Exception('Unexpected input')

    end

    def session
      @easy_translate_dev_session ||= GoogleDrive.login(EasyTranslateDev.configuration.google_user, EasyTranslateDev.configuration.google_password)
    end

    def spreadsheet
      @easy_translate_dev_spreadsheet ||= session.spreadsheet_by_key(EasyTranslateDev.configuration.google_spreadsheet_id).worksheets[0]
    end

    def translate_text(text, translate_from, translate_to)
      translate_array([text], translate_from, translate_to).first
    end

    def translate_array(array_to_translate, translate_from, translate_to)
      array_to_translate.each_with_index do |text, row|
        spreadsheet[1, row + 1] = text
        spreadsheet[2, row + 1] = "=GoogleTranslate(A#{row+1};\"#{translate_from}\";\"#{translate_to}\""
      end
      spreadsheet.synchronize
      results = []
      array_to_translate.each_with_index do |_, row|
        results << spreadsheet[2, row+1]
      end
      results
    end

    def translate_hash(hash, translate_from, translate_to)
      array_to_translate = traverse_hash(true, hash)
      translated_array = translate_array(array_to_translate, translate_from, translate_to)
      traverse_hash(false, hash, translated_array)
      hash
    end

    def traverse_hash(read = true, hash = {}, results = [])
      hash.each do |key, value|
        if value.is_a?(Hash)
          traverse_hash(read, value, results)
        elsif value.is_a?(Array)
          value.each { |v| traverse_hash(read, v, results) }
        elsif read && value.is_a?(String) && value.present?
          results << value
          hash[key] = 'TMP'
        elsif !read && value.is_a?(String) && value == 'TMP'
          hash[key] = results.shift
        end
      end
      results
    end

  end
end
