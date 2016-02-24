class MultiInsert < ::ServiceObject
  attr_reader :records, :opts

  def initialize(records, opts = {})
    @records = records.map(&:with_indifferent_access)
    @opts = opts.with_indifferent_access
    raise ArgumentError, "Must provide a model" unless self.opts[:model].present?
  end

  def values
    @values ||= opts.fetch(:values, [])
  end

  def model
    @model ||= opts[:model]
  end

  def ignore_attributes
    @ignore_attributes ||= ["id"] + opts.fetch(:ignore_attributes, [])
  end

  def manager
    @manager ||= ::Arel::InsertManager.new(ActiveRecord::Base).tap do |manager|
      manager.into ::Arel::Table.new(model.to_s.tableize)
    end
  end

  def table
    @table ||= ::Arel::Table.new(model)
  end

  def attribute_names
    return @attribute_names if @attribute_names.present?
    @attribute_names = model.attribute_names.dup
    ignore_attributes.each do |attribute|
      @attribute_names.delete(attribute)
    end
    @attribute_names
  end

  def inject_attribute_names_into_manager!
    return @injected if @injected.present?
    attribute_names.each { |k| manager.columns << table[k] }
    @injected = true
  end

  def inject_values!
    return @values_injected if @values_injected.present?
    records.each do |record|
      tmp_ary = []
      attribute_names.each { |c| tmp_ary << model.sanitize(record[c]) }
      values << "(#{tmp_ary.join(",")})"
    end
    @values_injected = true
  end

  def write!
    return @written if @written.present?
    ::ActiveRecord::Base.connection_pool.with_connection { |conn| conn.execute("#{manager.to_sql} VALUES #{values.join(",")}") }
    @written = true
  end

  def execute
    return false unless records.present?
    inject_attribute_names_into_manager!
    inject_values!
    write!

  rescue => exception
    raise "Multi-Insert: #{exception.message}"
  end
end

