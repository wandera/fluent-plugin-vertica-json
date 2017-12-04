module Fluent
  class VerticaJsonOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('verticajson', self)

    config_param :host,           :string,  :default => '127.0.0.1'
    config_param :port,           :integer, :default => 5433
    config_param :username,       :string,  :default => 'dbadmin'
    config_param :password,       :string,  :default => nil
    config_param :database,       :string,  :default => nil
    config_param :schema,         :string,  :default => nil
    config_param :table,          :string,  :default => nil
    config_param :ssl,            :bool,    :default => false

    def initialize
      super

      require 'vertica'
      require 'json'
    end

    def format(tag, time, record)
      record_altered = Hash[
          record.map{ |k, v|
            if v.is_a?(Hash) or v.is_a?(Array)
              [k, "#{v.to_json}"]
            else
              [k, v]
            end
          }
      ]

      $log.info "New data received to the buffer for the table #{@schema}.#{@table}"
      record_altered.to_json
    end

    def write(chunk)
      perm_table = "\"#{@schema}\".\"#{@table}\""

      chunk.open do |file|

        file_contents = file.read

        vertica.copy(<<-SQL) { |handle| handle.write(file_contents) }
          COPY #{perm_table}
          FROM STDIN
          PARSER fjsonparser()
          ENFORCELENGTH DIRECT
          REJECTED DATA AS TABLE #{@table}_rejected
        SQL

        vertica.close
        @vertica = nil
      end
      $log.info "Data successfully loaded to vertica table #{perm_table}."
    end

    private

    def vertica
      @vertica ||= Vertica.connect({
        :host     => @host,
        :user     => @username,
        :password => @password,
        :ssl      => @ssl,
        :port     => @port,
        :database => @database
      })
    end

  end
end
