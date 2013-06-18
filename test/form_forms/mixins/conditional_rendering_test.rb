require 'test_helper'

class CinditionalRenderingTest < ActionView::TestCase
  test "render conditionally with if" do
    with_form_for(@user) do |form|
      form.block(:name, :div, :id => :name) do |block|
        block.if { false }
        block.field(:name) {|f| f.input :name}
      end

      form.block(:credit_card, :div, :id => :credit_card) do |block|
        block.if { true }
        block.field(:credit_card) {|f| f.input :credit_card}
      end
    end

    assert_no_select 'form input#user_name'
    assert_select 'form > div#credit_card input.string#user_credit_card'
  end

  test "render conditionally with unless" do
    with_form_for(@user) do |form|
      form.block(:name, :div, :id => :name) do |block|
        block.unless { true }
        block.field(:name) {|f| f.input :name}
      end

      form.block(:credit_card, :div, :id => :credit_card) do |block|
        block.unless { false }
        block.field(:credit_card) {|f| f.input :credit_card}
      end
    end

    assert_no_select 'form input#user_name'
    assert_select 'form > div#credit_card input.string#user_credit_card'
  end

  test "render conditional with if and unless" do
    with_form_for(@user) do |form|
      form.block(:name, :div, :id => :name) do |block|
        block.if { true }
        block.unless { true }
        block.field(:name) {|f| f.input :name}
      end

      form.block(:credit_card, :div, :id => :credit_card) do |block|
        block.if { true }
        block.unless { false }
        block.field(:credit_card) {|f| f.input :credit_card}
      end

      form.block(:name, :div, :id => :action) do |block|
        block.if { false }
        block.unless { true }
        block.field(:action) {|f| f.input :action}
      end

      form.block(:name, :div, :id => :home_picture) do |block|
        block.if { false }
        block.unless { false }
        block.field(:home_picture) {|f| f.input :home_picture}
      end
    end

    assert_no_select 'form input.string#user_name'
    assert_select 'form > div#credit_card input.string#user_credit_card'
    assert_no_select 'form input#user_action'
    assert_no_select 'form input#user_home_picture'
  end
end
