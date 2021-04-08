require 'simple_xlsx_reader'
require 'pp'
require_relative 'builder'

workbook = SimpleXlsxReader.open 'Label_worx1.xlsx'
worksheets = workbook.sheets


def getYears(date1)
    tab = Array.new
    if date1
        tab = date1.split('/')
        return tab[2]
    end
end

build_xml(worksheets[0])

puts "Found #{worksheets.count} worksheets"