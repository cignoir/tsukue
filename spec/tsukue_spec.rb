require 'nokogiri'
require 'tsukue'

RSpec.describe Tsukue do
  it "has a version number" do
    expect(Tsukue::VERSION).not_to be nil
  end

  describe 'rowspan' do
    let(:html) do
      <<EOF
    <html><body><table>
    <tr><td>A</td><td>B</td></tr>
    <tr><td rowspan="2">1</td><td>2</td></tr> 
    <tr><td rowspan="2">3</td></tr>
    <tr><td>4</td></tr>
    </table></body></html>
EOF
    end

    let(:doc) {Nokogiri::HTML(html)}
    let(:table) {Tsukue::Table.new doc, '/html/body/table', {:dup_rows => dup_rows, :dup_cols => dup_cols}}

    context 'when dup_rows = false and dup_cols = false' do
      let(:dup_rows) {false}
      let(:dup_cols) {false}

      it 'should parse' do
        expect(table.columns.size).to eq 2
        expect(table[0].size).to eq 2
        expect(table[1].size).to eq 2
      end
    end

    context 'when dup_rows = true and dup_cols = false' do
      let(:dup_rows) {true}
      let(:dup_cols) {false}

      it 'should parse' do
        expect(table.columns.size).to eq 2
        expect(table[0].size).to eq 3
        expect(table[1].size).to eq 3
      end
    end

    context 'when dup_rows = false and dup_cols = true' do
      let(:dup_rows) {false}
      let(:dup_cols) {true}

      it 'should parse' do
        expect(table.columns.size).to eq 2
        expect(table[0].size).to eq 2
        expect(table[1].size).to eq 2
      end
    end

    context 'when dup_rows = true and dup_cols = true' do
      let(:dup_rows) {true}
      let(:dup_cols) {true}

      it 'should parse' do
        expect(table.columns.size).to eq 2
        expect(table[0].size).to eq 3
        expect(table[1].size).to eq 3
      end
    end
  end

  describe 'colspan' do
    let(:html) do
      <<EOF
    <html><body><table>
    <tr><td>A</td><td colspan="2">B</td></tr>
    <tr><td rowspan="2">A1</td><td>B1</td><td>C1</td></tr> 
    <tr><td>B2</td><td>C2</td></tr>
    <tr><td>A3</td><td>B3</td><td>C3</td></tr>
    <tr><td>A4</td><td colspan="2" rowspan="2">B4</td></tr>
    <tr><td>A5</td></tr>
    <tr><td rowspan="2">A1</td><td>B1</td><td>C1</td></tr> 
    <tr><td>B2</td><td>C2</td></tr>
    <tr><td>A3</td><td>B3</td><td>C3</td></tr>
    <tr><td>A4</td><td colspan="2" rowspan="2">B4</td></tr>
    <tr><td>A5</td></tr>
    </table></body></html>
EOF
    end

    let(:doc) {Nokogiri::HTML(html)}

    context 'when no option' do
      let(:table) {Tsukue::Table.new doc, '/html/body/table'}
      it 'should parse' do
        expect(table.columns.size).to eq 3
        expect(table[0].size).to eq 10
        expect(table[1].size).to eq 10
        expect(table[2].size).to eq 10
      end
    end

    context 'when dup_rows = false' do
      let(:dup_rows) {false}
      let(:table) {Tsukue::Table.new doc, '/html/body/table', {:dup_rows => dup_rows}}

      it 'should parse' do
        expect(table.columns.size).to eq 3
        expect(table[0].size).to eq 8
        expect(table[1].size).to eq 8
        expect(table[2].size).to eq 8
      end
    end

    context 'when dup_rows = false and dup_cols = false' do
      let(:dup_rows) {false}
      let(:dup_cols) {false}
      let(:table) {Tsukue::Table.new doc, '/html/body/table', {:dup_rows => dup_rows, :dup_cols => dup_cols}}

      it 'should parse' do
        expect(table.columns.size).to eq 3
        expect(table[0].size).to eq 8
        expect(table[1].size).to eq 8
        expect(table[2].size).to eq 6
      end
    end
  end

  describe 'yukihi' do
    let(:html) do
      <<EOF
    <html><body><table>
    <tr><td colspan="12">header1</td></tr>
    <tr><td colspan="12">header2</td></tr>
    <tr>
      <td rowspan="2">N-1</td>
      <td rowspan="2">ab</td>
      <td rowspan="2">c</td>
      <td rowspan="2">-</td>
      <td>d</td>
      <td>4-5</td>
      <td>3</td>
      <td>1</td>
      <td rowspan="2">-</td>
      <td rowspan="2">-</td>
      <td rowspan="2"></td>
      <td rowspan="2">QA</td>
    </tr>
    <tr>
      <td>e</td>
      <td>0-1</td>
      <td>1</td>
      <td>1</td>
    </tr>
    </table></body></html>
EOF
    end

    let(:doc) {Nokogiri::HTML(html)}

    context 'no option' do
      let(:table) {Tsukue::Table.new doc, '/html/body/table', {:header => false, :dup_rows => true, :dup_cols => true}}
      it 'should parse' do
        expect(table.rows.size).to eq 4
        expect(table.rows[0].size).to eq 12
        expect(table.rows[1].size).to eq 12
        expect(table.rows[2].size).to eq 12
        expect(table.rows[3].size).to eq 12
      end
    end
  end
end

