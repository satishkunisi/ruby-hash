require 'Prime'

class MyHash
  def initialize
    @buckets = Array.new(10) { [] }
  end
  
  def [](key)  
    tuple = tuple_for(key)
    tuple.nil? ? nil : tuple[1]
  end

  def []=(key, value)
    bucket = bucket_for(key)
    tuple = tuple_for(key)

    if tuple.nil?
      bucket << [key, value]
    else
      tuple[1] = value
    end

    check_bucket_size(bucket)
  end

  def tuple_for(key)
    bucket_for(key).find do |tuple|
      tuple[0].eql?(key)
    end
  end

  def keys
    @buckets.map { |bucket| bucket.map { |tuple| tuple[0] } }.flatten
  end

  def values
    @buckets.map { |bucket| bucket.map { |tuple| tuple[1] } }.flatten
  end

  private

  def num_buckets
    @buckets.length
  end

  def redistribute!
    new_size = num_buckets * 2

    until Prime.prime?(new_size)
      new_size += 1
    end
    
    new_buckets = Array.new(new_size) { [] }

    @buckets.each do |bucket|
      bucket.each do |tuple|
        bucket_idx = (tuple[0].hash % new_buckets.length)
        new_buckets[bucket_idx] << tuple
      end
    end

    @buckets = new_buckets
  end

  def check_bucket_size(bucket)
    redistribute! if bucket.length > 10
  end

  def bucket_idx(key)
    key.hash % num_buckets 
  end

  def bucket_for(key)
    @buckets[bucket_idx(key)]
  end
end
