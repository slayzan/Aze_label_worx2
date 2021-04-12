require 'pp'
require_relative 'lib/utils'
require 'spreadsheet'
require 'nokogiri'

begin
    workbook = Spreadsheet.open ARGV[0]
    worksheets = workbook.worksheets
    ws = worksheets[0]
rescue
    abort "Error while opening file please open .xls files only"
end

$catalog_current = ws.rows[1][1]
$price = 1.29

#Build xml file
def sendPackage(package,xml)
i = 1
    xml.release{
        xml.title package[0][3]
        xml.slug "#{package[0][2]}_#{package[0][3]}_#{package[0][1]}"
        xml.sku_ep package[0][1]
        xml.artists package[0][2]
        xml.label package[0][0]
        xml.genres getGenres(package)
        xml.years getYears(package[0][4])
        xml.type "release"
        xml.price getPrice(package)
        xml.description package[0][5]
        xml.owners "label worx"
        xml.product_visibility "visible"
        xml.featured_image "https://www.aze.digital/wp-content/uploads/#{getYears(package[0][4])}/#{package[0][1]}"
        xml.download_file_name "#{package[0][2]} - #{package[0][3]} #{package[0][1]}.wav"
        xml.playlist_data buildDataTrack(package)
        package.each do |row|
            xml.post{
                xml.title "#{row[7]} - #{row[9]}"
                xml.sku "#{row[1]}-#{i}"
                xml.description "#{row[5]}"
                xml.slug "#{row[1]}_#{i}"
                xml.sku_ep row[1]
                xml.artists row[6]
                xml.label row[0]
                xml.genre row[9]
                xml.years getYears(row[4])
                xml.type "song"
                xml.price 1.29
                xml.owners "label worx"
                xml.product_visibility "hidden"
                xml.featured_image "https://www.aze.digital/wp-content/uploads/#{getYears(row[4])}/#{row[1]}"
                xml.download_file_name "#{row[6]} - #{row[7]} #{row[1]}.wav"
                xml.download_file_name row[8].nil? ? "<a href=\"http:\/\/player.yoyaku.io/mp3/#{row[1]}_#{i}.mp3\">#{row[6]} - #{row[7]}</a>\n" : "<a href=\"http:\/\/player.yoyaku.io/mp3/#{row[1]}_#{i}.mp3\">#{row[6]} - #{row[7]} (#{row[9]})</a>\n"
            }
        end
    }
end

def readXls(ws,xml)
    ensemble = Array.new
    i = 1
    j = 0
    while ws.rows[i]
        if ws.rows[i] == nil
            break
        end
        if  ws.rows[i][1] == $catalog_current
            ensemble[j] =  ws.rows[i]
            j = j + 1
            i = i +1
        else
            sendPackage(ensemble,xml)
            $catalog_current = ws.rows[i][1]
            j = 0
            ensemble.clear
        end
    end
end


def build_xml(ws)
    i = 0
    j = 0
    builder = Nokogiri::XML::Builder.new do |xml|
       xml.data{
           readXls(ws,xml)
       }
    end
        File.open("data/output.xml", 'w'){ |f| f.write(builder.to_xml)}
end


build_xml(ws)