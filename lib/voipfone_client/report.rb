module VoipfoneClient
  class Report < Session
    attr_accessor :type, :date, :range, :extension_filter

    class << self
      # Retrieves call record summaries according to requested criteria...
      #
      # @param type can be :incoming, :outgoing or :missed
      # @param date as a Date (default is today)
      # @param range can be set to :day or :month (defaults to monthly report)
      # @param extension_filter is the required ext number or :all (default all)
      # @return [Array] of call record summaries by day or by hour (according
      # to range)

      def call_records_summary( call_type = :outgoing,
                                date = Date.today,
                                range = :month,
                                extension_filter = :all)
        if range == :month
          query_date = date.strftime('%Y-%m')
          response_unit = :days
        else
          query_date = date.strftime('%Y-%m-%d')
          response_unit = :hours
        end

        session = self.new
        query = "callRecordsSummary/#{call_type.to_s}/#{query_date}/#{range}/#{extension_filter}"
        request = session.browser.get("#{VoipfoneClient::API_GET_URL}?#{query}")
        session.parse_response(request)[ query.to_sym][ response_unit]
      end


      # Returns call record details according to requested criteria.
      # Warning: these can be lengthy...
      #
      # @param type can be :incoming, :outgoing or :missed
      # @param date as a Date (default is today)
      # @param range can be set to :day or :month (defaults to daily report)
      # @param extension_filter is the required ext number or :all (default all)
      # @return [Array] of call record hashes containing date and time, to,
      # from, duration and cost.

      def call_records( call_type = :outgoing,
                        date = Date.today,
                        range = :day,
                        extension_filter = :all)
        page = 1
        records = []
        query_date = date.strftime('%Y-%m')
        day = date.strftime( '%d')

        parameters = {
          "type"      => call_type.to_s,
          "day"       => day.to_s,
          "dateRange" => query_date,
          "range"     => range.to_s,
          "extFilter" => extension_filter.to_s
        }

        session = self.new
        query = "#{VoipfoneClient::API_POST_URL}?callRecordsSearch"

        begin
          parameters[ "page"] = page.to_s
          request = session.browser.post( query, parameters)
          raw = JSON.parse( request.body)
          records += raw.first.collect do |rec|
            { datetime: DateTime.parse( rec[0]),
              from: rec[1],
              to: rec[2],
              duration: rec[3],
              cost: rec[4],
              package_minutes: rec[5]
            }
          end
          page += 1
        end until raw.empty? || raw.first.empty?

        return records
      end
    end
  end
end
