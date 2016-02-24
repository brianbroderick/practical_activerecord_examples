require "test_helper"
require "multi_insert"

class MultiInsertTest < ::ActiveSupport::TestCase

  def setup
    @subject = ::MultiInsert.new([record], { :model => ::Document })
  end

  def test_class_interface
    subject = mock
    subject.expects(:execute).returns(:bar)
    ::MultiInsert.expects(:new).with(:foo).returns(subject)
    assert_equal(:bar, ::MultiInsert.execute(:foo))
  end

  def test_interface
    record = mock
    record.expects(:with_indifferent_access).returns(:records)
    subject = ::MultiInsert.new([record], { :model => :model })
    assert_equal([:records], subject.records)
    assert_equal([], @subject.values)
    assert_equal(:model, subject.model)
    assert_equal(::Document, @subject.model)
    assert_equal(["id"], @subject.ignore_attributes)
  end

  def test_ignore_attributes
    @subject = ::MultiInsert.new([record], { :model => Object, :ignore_attributes => ["authors"] })
    expected = %w(id authors)
    assert_equal(expected, @subject.ignore_attributes)
  end

  def test_manager
    result = @subject.manager
    assert_equal("documents", result.ast.relation.name)
  end

  def test_table
    result = @subject.table
    assert_equal("Document", result.name)
  end

  def test_attribute_names
    expected = sorted_attribute_names
    result = @subject.attribute_names.sort
    assert_equal(expected, result)
  end

  def test_inject_attribute_names_into_manager
    @subject.inject_attribute_names_into_manager!
    expected = sorted_attribute_names
    result = @subject.manager.columns.map(&:name).sort
    assert_equal(expected, result)
  end

  def test_write
    connection_pool = mock
    connection_pool.expects(:with_connection).returns(true)
    ::ActiveRecord::Base.expects(:connection_pool).returns(connection_pool)
    assert(@subject.write!)
  end

  def test_execute
    @subject.expects(:inject_attribute_names_into_manager!).returns(true)
    @subject.expects(:inject_values!).returns(true)
    @subject.expects(:write!).returns(true)
    assert(@subject.execute)
  end

  def attribute_names
    %w(name seo_url document_type_id created_at updated_at)
  end

  def attribute_values
    [1, 1, 1, 1, 200, nil, 1]
  end

  def record
    attribute_names.zip(attribute_values).inject({}) do |h, (k, v)|
      h[k] = v
      h
    end
  end

  def sorted_attribute_names
    attribute_names.sort.map(&:to_s)
  end

end
