require 'nokogiri'
require 'open-uri'

module Tsukue
  class Parser
    # extract_table("http://www.bs4.jp/table/index.html", "/html/body/table/tr/td/table")
    def self.extract_table(doc, xpath)
      rows = []
      table = doc.xpath(xpath)
      table = table.first if table.is_a?(Array)
      rows = table.xpath("./thead/tr|./tr|./tbody/tr").collect do |row|
        row.xpath("./td|./th").collect do |col|
          col
        end
      end
      rows
    end

    def self.extract_column_headers(rows, dup_rows, dup_cols, has_header)
      headers = []

      if has_header
        rows.first.collect do |col|
          header = TableColumn.new(col)
          headers << header
          colspan = col["colspan"].to_i rescue 1
          (colspan-1).times do
            headers << TableColumn.new(col)
          end
        end
        rows.delete_at(0)
      else
        rows.first.collect do |col|
          header = TableColumn.new(nil)
          headers << header
          colspan = col["colspan"].to_i rescue 1
          (colspan-1).times do
            headers << TableColumn.new(nil)
          end
        end
      end
      headers
    end

    def self.extract_nodes(input_rows, headers, dup_rows, dup_cols)
      data = input_rows.collect do |row|
        row.collect do |ele|
          node = TableNode.new(ele)
        end
      end

      columns = []
      curr_x = 0
      curr_y = 0
      data.each do |row|
        columns[curr_y] = [] unless columns[curr_y]

        curr_y = 0
        row.each do |node|
          rowspan = node.rowspan - 1
          colspan = node.colspan - 1

          (0..rowspan).each do |x|
            (0..colspan).each do |y|
              columns[curr_y+y] = [] unless columns[curr_y+y]
              while columns[curr_y+y][curr_x+x]
                curr_y += 1
                columns[curr_y+y] = [] unless columns[curr_y+y]
              end

              if (x == 0 || dup_rows) && (y == 0 || dup_cols)
                columns[curr_y+y][curr_x+x] = node
              else
                columns[curr_y+y][curr_x+x] = EmptyTableNode.new(node.element)
              end
            end
          end
          curr_y += 1
        end
        curr_x += 1
      end

      columns.each_index do |col_index|
        columns[col_index].each do |node|
          if headers[col_index]
            headers[col_index].children << node unless node.class == EmptyTableNode
          end
        end
      end

      columns
    end

    def self.extract_rows(columns)
      col_size = columns.size
      row_size = columns.first.children.size

      rows = []
      (0..(row_size - 1)).each do |row_index|
        cols = []
        (0..(col_size - 1)).each do |col_index|
          cols << (columns[col_index].children[row_index] rescue nil)
        end
        rows << cols
      end
      rows
    end
  end
end