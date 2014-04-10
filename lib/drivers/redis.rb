module Drivers
  class Redis
    class << self

      def namespace(namespace)
        $redis.scan_each(:match => "#{namespace}*").to_a
      end

      def flush_namespace(namespace)
        $redis.scan_each(:match => "#{namespace}*").to_a.each do |key|
          $redis.del(key)
        end
      end

      def get(key)
        if exists? key
          case $redis.type key
          when "string"
            $redis.get key
          when "list"
            $redis.lrange key, 0, -1
          when "set"
            $redis.smembers key
          when "zset"
            $redis.zrange key, 0, -1
          when "hash"
            $redis.hgetall(key).transform_keys { |key| key.to_sym }
          end
        else
          nil
        end
      end

      def get_as_hash(key)
        ret = {}
        ret.store key, get(key)
      end

      def type(key)
        $redis.type key
      end

      def exists?(key)
        $redis.exists key
      end

      def member?(group_name, member_name)
        $redis.sismember group_name, member_name
      end

      def member(group_name, member_name)
        return nil unless member?(group_name, member_name)
        get "#{group_name}:#{member_name}"
      end

      def members(key)
        member_keys(key).map { |member_id| member(key, member_id) }
      end

      def members_as_hash(key)
        ret = HashWithIndifferentAccess.new
        member_keys(key).map { |member_id| ret.store(member_id, member(key, member_id)) }
        ret
      end

      def member_keys(key)
        $redis.smembers(key)
      end

      def delete(key)
        $redis.del key
      end

    end
  end
end