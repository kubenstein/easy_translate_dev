require "easy_translate_dev/version"
require 'easy_translate_dev/configuration'
require 'easy_translate_dev/patch'
require 'open-uri'

module EasyTranslateDev
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
    patch_easy_translate!
  end

  def self.patch_easy_translate!
    EasyTranslate.send(:extend, EasyTranslateDev::Patch)
  end

end

