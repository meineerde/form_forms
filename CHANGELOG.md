# FormForms Change Log

## v0.2.0 - 2012-06-17

* Add generic `sub_form` element
* Add `table_fields` element to render a one-to-many or many-to-many
  association in a table.

## v0.1.0 - 2012-06-16

First release containing the basic functionality to create forms:

* parent `Form` class
* `field` to render a single field
* `fields` to render an association
* `fieldset` to group elements in a HTML fieldset
* `block` to group elements in an arbitrary HTML block tag

It also introduces the basic `FormRegistry` class