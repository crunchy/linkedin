module LinkedIn
  module Api

    module QueryMethods
      PARAMETERS = %w{start count modified modified-since}

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      private

        def simple_query(path, options={})
          fields = options[:fields] || LinkedIn.default_profile_fields

          if options[:public]
            path += ":public"
          elsif fields
            path += field_selector(fields)
          end 
          
          PARAMETERS.each do |param|
            path += "?#{param}=#{options[param.to_sym]}" if options[param.to_sym]
          end

          Mash.from_json(get(path))
        end

        def person_path(options)
          path = "/people/"
          if options[:id]
            path += "id=#{options[:id]}"
          elsif options[:url]
            path += "url=#{sanatize_value(options[:url])}"
          else
            path += "~"
          end
        end

    end

  end
end