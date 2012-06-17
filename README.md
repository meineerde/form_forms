# FormForms [![Build Status](https://secure.travis-ci.org/meineerde/form_forms.png)](http://travis-ci.org/meineerde/form_forms) [![Dependency Status](https://gemnasium.com/meineerde/form_forms.png?travis)](https://gemnasium.com/meineerde/form_forms)

Configurable forms for Rails 3, based on the excellent
[simple_form](https://github.com/plataformatec/simple_form) gem.

The goal of this gem is to provide forms (as in views) which are flexible
enough to fulfill their intended usage but be able to be configured by
plugins. Thus plugins can easily add, delete and edit form fields without
having to override whole views (which are almost impossible to patch) or
having to monkey patch existing code which is hard to maintain.

form_forms is originally intended to be used with the simple_form gem and uses
its API in several of its shipped element definitions. While it is possible
to not use those and provide custom definitions, we require simple_form as
a dependency right now.

# Installation

Add this line to your application's Gemfile:

    gem 'form_forms'

and then run `bundle install`.

Or install it yourself using

    gem install form_forms

# Usage

form_forms is built around the idea that a Rails application is able to
define arbitrary forms using a simple yet powerful DSL. These form
definitions are typically contained in the `lib` directory and are loaded
during initialization. During rendering of a request, the view simply
retrieves an existing form definition and renders that form by parameterizing
it with some data object (e.g. an ActiveRecord model instance).

## Defining Forms

    FormForms::Registry[:my_form] = FormForms::Form.new() do |form|
      form.field(:subject) {|f| f.input :subject}
      form.field(:link) do |f|
        content_tag :p do
          content_tag(:a, :href => hint_path){ "This is a hint" }
        end
      end
    end

This will register a new form object under the name `:my_form` which will
render two fields: an input field for the `subject` attribute of the passed
model instance and a "static" hint. Each fields definition has a block which
defines what will actually be rendered. This block will be executed in the
context of the current view which allows you to use any helper methods you
have defined in your application.

Each of the fields is identified with a name, passed as the first parameter
to the field definition. Using this name, plugins can later change or remove
individual fields. As such, the name of each field has to be unique on each
level of the form.

The form can be rendered in a view by using something like this:

    <%= FormForms::Registry[:my_form].render(@model, self) %>

The render method takes two parameters: the model object that should be used
as the base object for the form and a view instance (which can be almost
always passed as `self`). The view instance is used to render the form fields.

## Form Registry

To handle several forms, form_forms ships with a simple registry. If you
need a more powerful system, you are of course free to handle your form
objects in any other way.

The default registry provides a hash-like interface on the
`FormForms::Registry` class. You can either directly assign form objects to
keys there as shown above or you can use the `register` method of all `Form`
classes as a shorthand:

    FormForms::Form.register(:my_name) do |form|
      # form definition
      # [...]
    end

## Adapting an existing form from plugins

Once a form is defined, it fields can be added, changed, and removed later on.

New fields can be added either before or after already existing elements:

    FormForms::Registry[:my_form].field_before(:description, :name) {|f| f.input :name}
    FormForms::Registry[:my_form].field_after(:credit_card, :ccv) {|f| f.input :ccv}

This will insert the new field `:name` before the already defined field
`:description` and insert the field `:ccv` after the existing `:credit_card`
field. You can also insert elements at the very beginning and the very end of
the elements list:

    FormForms::Registry[:my_form].field_first(:salutation) {|f| f.input :salutation}
    FormForms::Registry[:my_form].field_last(:accept_terms) {|f| f.input :accept_terms}

Each of the element types defines the five methods

* `form.<type>`
* `form.<type>_first`
* `form.<type>_before`
* `form.<type>_after`
* `form.<type>_last` (an alias to `form.<type>`)

Each of the methods accepts all parameters of the respective element type.
Only the `form.<type>_before` and `form.<type>_after` methods take the name of
the element that should act as the respective index as the first argument.

Finally, there is the `form.delete` method which simply takes the name of an
element as its parameter. It complete deletes this element from the element
list, preventing it from rendering:

    FormForms::Registry[:my_form].delete(:salutation)

# Element Types

form_forms already ships with different element types which allow you to
create most of the common form elements. These elements are used to define
the actual form body.

## `field`

The most basic element type is a `field` which is rendered to a basic form
field or a snipped of static code. Fields are the most basic form of elements
and typically made of the bulk of the form definition.

For the definition, they take a `name` which is used for identifying the
field in the form as well as a generator block to render the field. The name,
always being the first attribute is *only* used for identifying the element
later on and is not passed to the generator block during rendering and thus
can be chosen arbitrarily. It must only be unique in the current scope.
Generally, it is advisable to chose a name similar to the model field that is
actually rendered.

The block receives one argument during rendering: the form builder, i.e. the
simple_form object. Alternatively to a block, you can also directly pass a
string which will be emitted as-is. The usual HTML escape rules apply, i.e.
you have to use `html_save` correctly to avoid rendering unsafe data.

## `fieldset`

A fieldset is used to group fields in a single form. During rendering, this
elements will create an HTML `<fieldset>` tag and a `<legend>`. As a fieldset
naturally contains  other fields, its generator block can be used to define
fields.

    FormForms::Registry[:user] = FormForms::Form.new() do |form|
      form.field(:street) {|f| f.input :street }
      form.field(:city) {|f| f.input :city }
      form.fieldset(:payment, :id => "payment") do |fieldset|
        fieldset.legend "Credit Card Data"
        fieldset.field(:credit_card) {|f| f.input :credit_card}
        fieldset.field(:ccv) {|f| f.input :ccv}
      end
    end

The fieldset element creates a new scope (or sub-form) which can be
arbitrarily nested. Apart from all the other elements types, it has a special
sub element: the `legend`. It doesn't take a name as its first parameter.
Instead, it just takes a string or a generator block (similar to a `field`)
which is used to render the content of the `<legend>` tag of the fieldset.

The fieldset tag receives one additional (optional) hash argument which
allows to define additional options (e.g. additional HTML attributes) for the
the fieldset tag. All options supported by Rails' `content_tag` helper are
allowed here.

## `block`

A `block` creates a sub-form which nests form elements inside a HTML block
(e.g. a `<div>`) which is sometimes necessary to further group elements and
markup the form using custom CSS rules. This element works similar to the
`fieldset` described above.

    FormForms::Registry[:user] = FormForms::Form.new() do |form|
      form.field(:street) {|f| f.input :street }
      form.block(:box, :div, :class => "red-and-blinky") do |block|
        block.field(:sell_your_soul) {|f| f.input :sell_your_soul}
      end
    end

Here, the block element takes the name of the newly created element, the type
of HTML tag to create and a hash of options to pass to the `content_tag`
helper of ´Rails which creates the tag internally.

The generator block creates a new element scope similar to the fieldset
element.

## `fields`

Using fields, you can create sub-forms for association of the model object.
This allows you to create forms for nested elements.

    FormForms::Registry[:user] = FormForms::Form.new() do |form|
      form.field(:name) {|f| f.input :name}

      args = lambda{|f| {:collection => Tag.all} }
      form.fields(:tags, :tags, args) do |tags|
        tags.field(:name) {|f| f.input :name}
      end
    end

The fields element type takes four arguments. The first is the name of the
element as usual. The second is the name of the association which is to be
rendered. For the example above, the `User` model is defined as follows:

    class User < ActiveRecord::Base
      has_many :tags
    end

The third argument is an options hash which is passed to association render
function of simple_form. And finally we have the generator block which works
the same as for fieldsets and blocks.

In our example above, we pass the `:collection` attribute in the options
which instructs simple_form to render a select box containing the elements
of the passed collection. Here we have to do a little trick. If we simple
pass the array of tags here as in

    form.fields(:tags, :tags, :collection => Tag.all) do |tags|

the `Tags.all` would be evaluated just once, during the initialization of the
application. New tags created later would not be included. To fix this, we
pass a `lambda` block which is evaluated each time again during the form
rendering. This lambda is expected to return a hash of options which is
passed to the `association` method of simple_form.

# Development

Install dependencies with

    bundle install

then run tests with

    bundle exec rake

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

> take my code with you<br/>
> and do whatever you want<br/>
> but please don’t blame me<br/>

[License Haiku](http://www.aaronsw.com/weblog/000360)

This library is licensed under the MIT license. See the `LICENSE` file for
more details.