# frozen_string_literal: true

module StimulusRailsDatatables
  class BaseDatatable < AjaxDatatablesRails::ActiveRecord
    def current_page
      params.fetch(:start, 0).to_i
    end

    def query_filters
      (filters || {}).symbolize_keys.compact_blank!
    end

    private

    # Filters according to the provided arguments with OR condition.
    # @param [Hash{Class => Array<Symbol>] **arguments Filtering objects based on columns.
    # @return [Proc] A lambda function that filters the records based on the provided arguments.
    # :nocov:
    def or_search_by_fields(**arguments)
      lambda do |column, _|
        conditions = []

        arguments.each do |model, fields|
          arel_table = model.arel_table
          fields.each do |field|
            conditions << arel_table[field].matches("%#{column.search.value}%")
          end
        end

        conditions.reduce { |combination, condition| combination.or(condition) }
      end
    end
    # :nocov:

    def filters
      filter_hash = params[:filters]
      filter_hash.permit!.to_h if filter_hash
    end
  end
end
