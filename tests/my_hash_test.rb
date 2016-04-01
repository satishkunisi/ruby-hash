require 'minitest/autorun'
require 'minitest/benchmark'
require 'benchmark'

require_relative '../my_hash'

class TestMyHash < MiniTest::Unit::TestCase
  def setup
    @my_hash = MyHash.new 
  end

  def test_set_key
    @my_hash['foo'] = 'bar'
    assert @my_hash['foo'] == 'bar'
  end

  def test_replace_key
    @my_hash['foo'] = 'bar'
    @my_hash['foo'] = 'baz'

    assert_equal(1, @my_hash.keys.length)
  end

  def test_set_symbol
    @my_hash[:foo] = 'bar'
    @my_hash[:foo] = 'baz'

    assert_equal('baz', @my_hash[:foo])
  end


  def test_replace_symbol
    @my_hash[:foo] = 'bar'
    @my_hash[:foo] = 'baz'

    assert_equal(1, @my_hash.keys.length)
  end
  
  def test_redistribute
    1000.times { |n| @my_hash["foo#{n}"] = "bar#{n}" }
    assert_equal(1000, @my_hash.keys.length)
  end


  def test_redistribute
    1000.times { |n| @my_hash["foo#{n}"] = "bar#{n}" }
    assert_equal(1000, @my_hash.keys.length)
  end
end

class BenchMyHash < Minitest::Benchmark
  def self.bench_range
    (0...1000).to_a
  end

  def bench_my_hash_lookup
    my_hash = MyHash.new

    num_elements.times do |n| 
      my_hash["foo#{n}"] = "bar#{n}"
    end
    
    assert_performance_constant 0.999 do |n|
      my_hash["foo#{n}"]
      puts
    end
  end

  def bench_my_hash_writes
    my_hash = MyHash.new

    assert_performance_constant 0.999 do |n|
      my_hash["foo#{n}"] = "bar#{n}" 
      puts
    end
  end

  private

  def num_elements 
    self.class.bench_range.last
  end
end
