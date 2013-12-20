require 'google_drive'

module EasyTranslateDev
  module Patch

    HASH_VALUE_UNIQUE_REPLACEMENT = 'TMP'

    def translate(input, options = {}, http_options = {})
      translate_from = (options[:from] || 'en').to_s
      translate_to = options[:to].to_s
      return text if translate_to == translate_from

      return translate_hash(input, translate_from, translate_to) if input.is_a?(Hash)
      return translate_array(input, translate_from, translate_to) if input.is_a?(Array)
      return translate_text(input, translate_from, translate_to) if input.is_a?(String)
      raise Exception('Unexpected input, only: String, Hash, Array allowed!')
    end

    def session
      @easy_translate_dev_session ||= GoogleDrive.login(EasyTranslateDev.configuration.google_user, EasyTranslateDev.configuration.google_password)
    end

    def spreadsheet
      @easy_translate_dev_spreadsheet ||= session.spreadsheet_by_key(EasyTranslateDev.configuration.google_spreadsheet_id)
    end

    def translate_text(text_to_translate, translate_from, translate_to)
      translate_array([text_to_translate], translate_from, translate_to).first
    end

    def cleanup_worksheet
      worksheet = create_worksheet
      yield(worksheet)
      worksheet.delete
    end

    def create_worksheet
      spreadsheet.add_worksheet('EasyTranslateDev', max_rows = 10000, max_cols = 20)
    end

    def translate_array(array_to_translate, translate_from, translate_to)
      translated_array = []
      cleanup_worksheet do |worksheet|
        array_to_translate.each_with_index do |text, index|
          row = index + 2
          worksheet[row, 1] = text
          worksheet[row, 2] = "=GoogleTranslate(A#{row};\"#{translate_from}\";\"#{translate_to}\")"
        end
        worksheet.synchronize
        array_to_translate.size.times do |index|
          row = index + 2
          translated_array << worksheet[row, 2]
        end
      end
      translated_array
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
        elsif value.is_a?(Array) && (value.empty? || value.first.is_a?(Hash))
          value.each { |v| traverse_hash(read, v, results) }
        elsif value.is_a?(Array) && value.first.is_a?(String)
          if read
            results += value
            hash[key] = Array.new(value.size, HASH_VALUE_UNIQUE_REPLACEMENT)
          else
            hash[key] = results.shift(value.size)
          end
        elsif value && value.is_a?(String) && value.present?
          if read
            results << value
            hash[key] = HASH_VALUE_UNIQUE_REPLACEMENT
          else
            hash[key] = results.shift if value == HASH_VALUE_UNIQUE_REPLACEMENT
          end
        end
      end
      results
    end

  end
end
