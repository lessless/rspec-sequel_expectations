module RSpec
  module Matchers
    module Sequel
      # TODO: refactor with Sequel API
      # http://www.rubydoc.info/gems/sequel/4.13.0/Sequel/Postgres/EnumDatabaseMethods
      class HaveEnum
        def matches?(db)
            x = db.fetch("SELECT '#{@enum_name}'::regtype;").first
            x[:regtype] == @enum_name
          rescue ::Sequel::DatabaseError => e
            return false if e.message[0..18] == 'PG::UndefinedObject'
            raise e
        end
        
        def failure_message_when_negated
          "expected database not to have enum '#{@enum_name}'"
        end
        
        def failure_message
          "expected database to have enum '#{@enum_name}'"
        end
        
        private
        def initialize(enum_name)
          @enum_name = enum_name
        end
      end
      
      def have_enum(enum_name)
        HaveEnum.new(enum_name)
      end
    end
  end
end
