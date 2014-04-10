module Utils
  module Redis
    class Namespace
      class << self

        def list
          namespaces = []
          all_keys = Drivers::Redis.namespace("")
          all_keys.each do |key|
            namespace = key.split(":").shift
            namespaces.push namespace unless namespaces.include? namespace
          end

          namespaces
        end

        def top_level
          all_keys = Drivers::Redis.namespace("")
        end

        def details(root = "")
          root.blank? ? root_key = "" : root_key = "#{root}:"

          puts "\n\nSearching with Key: #{root_key}* from root: #{root}\n\n\n"

          namespaces = hash

          Drivers::Redis.namespace("#{root_key}*").each do |key|
            parts = key.gsub("#{root_key}", "").split(":")
            namespace = "#{root_key}#{parts.shift}"
            child_key = parts.join(":")

            unless child_key == ""
              if root_key == "#{namespace}:"
                to_store = "#{root_key}#{child_key}"
              else
                to_store = "#{namespace}:#{child_key}"
              end

              if namespaces[namespace].present?
                namespaces[namespace].push "#{to_store}"
              else
                namespaces[namespace] = ["#{to_store}"]
              end
            end
          end

          response = []

          namespaces.each_pair do |namespace, keys|
            key_breakdown = []
            keys.each do |key|
              key_breakdown.push({
                name: key,
                type: Drivers::Redis.type(key),
                value: Drivers::Redis.get(key)
              })
            end

            response.push({
              name: namespace,
              keys: key_breakdown
            })
          end

          File.open(Rails.root.join("log","redis_namespaces.yaml"), "w") do |f|
            f.write(response.to_yaml)
          end

          response
        end

        def delete(namespace)
          puts "Deleting namespace: #{namespace}"
          begin
            keys = Drivers::Redis.namespace(namespace)
            keys.each do |key|
              $redis.del key
            end

            return true
          rescue
            return false
          end
        end

        def hash
          HashWithIndifferentAccess.new
        end

      end
    end
  end
end