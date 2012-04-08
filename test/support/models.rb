# All of this is stolen from simple_form

Column = Struct.new(:name, :type, :limit)
Association = Struct.new(:klass, :name, :macro, :options)

class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :company, :company_id, :time_zone, :active, :age,
    :description, :created_at, :updated_at, :credit_limit, :password, :url,
    :delivery_time, :born_at, :special_company_id, :country, :tags, :tag_ids,
    :avatar, :home_picture, :email, :status, :residence_country, :phone_number,
    :post_count, :lock_version, :amount, :attempts, :action, :credit_card, :gender

  def initialize(options={})
    @new_record = false
    options.each do |key, value|
      send("#{key}=", value)
    end if options
  end

  def new_record!
    @new_record = true
  end

  def persisted?
    !@new_record
  end

  def company_attributes=(*)
  end

  def tags_attributes=(*)
  end

  def column_for_attribute(attribute)
    column_type, limit = case attribute.to_sym
      when :name, :status, :password then [:string, 100]
      when :description then [:text, 200]
      when :age then :integer
      when :credit_limit then [:decimal, 15]
      when :active then :boolean
      when :born_at then :date
      when :delivery_time then :time
      when :created_at then :datetime
      when :updated_at then :timestamp
      when :lock_version then :integer
      when :home_picture then :string
      when :amount then :integer
      when :attempts then :integer
      when :action then :string
      when :credit_card then :string
    end
    Column.new(attribute, column_type, limit)
  end

  def self.human_attribute_name(attribute)
    case attribute
      when 'name'
        'Super User Name!'
      when 'description'
        'User Description!'
      when 'company'
        'Company Human Name!'
      else
        attribute.humanize
    end
  end

  def self.reflect_on_association(association)
    case association
      when :company
        Association.new(Company, association, :belongs_to, {})
      when :tags
        Association.new(Tag, association, :has_many, {})
      when :first_company
        Association.new(Company, association, :has_one, {})
      when :special_company
        Association.new(Company, association, :belongs_to, { :conditions => { :id => 1 } })
    end
  end

  def errors
    @errors ||= begin
      hash = Hash.new { |h,k| h[k] = [] }
      hash.merge!(
        :name => ["can't be blank"],
        :description => ["must be longer than 15 characters"],
        :age => ["is not a number", "must be greater than 18"],
        :company => ["company must be present"],
        :company_id => ["must be valid"]
      )
    end
  end

  def self.readonly_attributes
    [:credit_card]
  end
end
