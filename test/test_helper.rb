require 'bundler'
Bundler.setup

require 'form_forms'

require 'test/unit'
require 'minitest/spec'

ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'action_view/test_case'
require 'action_view/test_helper'
require "rails/test_help" # adds stuff like @routes, etc.
require 'sqlite3'
require 'active_record'


class ActiveRecordMock < ActiveRecord::Base
  establish_connection(:adapter => "sqlite3", :database => ":memory:")

  alias_method :save, :valid?
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end
