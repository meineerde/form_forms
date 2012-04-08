require 'bundler'
Bundler.setup

$:.unshift File.expand_path("../../lib", __FILE__)
require 'form_forms'
require 'simple_form'

require 'test/unit'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'

require 'active_support/core_ext/module/deprecation'
require 'action_view/test_case'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each do |file|
  require file
end
I18n.default_locale = :en

class ActionView::TestCase
  include SimpleForm::ActionViewExtensions::FormHelper
  include MiscHelpers

  setup :set_controller
  setup :setup_new_user

  def set_controller
    @controller = MockController.new
  end

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'New in SimpleForm!',
      :description => 'Hello!',
      :created_at => Time.now
    }.merge(options))
  end

  def protect_against_forgery?
    false
  end

  def user_path(*args)
    '/users'
  end
  alias :users_path :user_path
end