module Tsukue
  class Table
    attr_reader :nodes, :columns, :rows

    def initialize(doc, xpath_to_table = "//table[0]", options = {})
      header = options.has_key?(:header) ? options[:header] : true
      dup_rows = options.has_key?(:dup_rows) ? options[:dup_rows] : true
      dup_cols = options.has_key?(:dup_cols) ? options[:dup_cols] : true

      table = Parser.extract_table(doc, xpath_to_table)
      @columns = Parser.extract_column_headers(table, dup_rows, dup_cols, header)
      @nodes = Parser.extract_nodes(table, @columns, dup_rows, dup_cols)
      @rows = Parser.extract_rows(@columns)
    end

    def to_s
      "Table<#{@columns.collect {|h| h.to_s}.join(",")}>"
    end

    # get column by index
    def [](index)
      @columns[index]
    end
  end
end