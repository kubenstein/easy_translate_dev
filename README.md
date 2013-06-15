EasyTranslateDev
=============

EasyTranslateDev is a hack that allows you not to pay for translations using [EasyTranslate gem](https://github.com/seejohnrun/easy_translate).
It is made to use in development environment only.

Idea
-------
EasyTranslateDev use google spreadsheet document to make translations.

Installation
-------
Put this line into your `Gemfile`:

	group :development do
  		gem 'easy_translate_dev', git: 'git://github.com/kubenstein/easy_translate_dev.git'
  	end

Usage
-----
Add this configuration to your `development.rb` config file:

	EasyTranslateDev.configure do |config|
		config.google_user = 'yourgoogleemail@gmail.com'
		config.google_password = 'yourpassword'
		config.google_spreadsheet_id = '0AgHQJUd_8ANrdDnhduPanvlNjRxbzJReDJDdXpWcGc'
	end

google_spreadsheet_id can be found in url pointing at the spreadsheet. Url looks like:

https://docs.google.com/spreadsheet/ccc?key=0AgHQJUd_8ANrdDnhduPanvlNjRxbzJReDJDdXpWcGc#gid=0

You have to create spreadsheet.

Credits
-------
Inspired by [this stack overflow post](http://stackoverflow.com/a/8543979).
	
