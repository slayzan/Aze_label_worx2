require 'pp'
require_relative 'lib/builder'
require 'spreadsheet'
require 'nokogiri'


workbook = Spreadsheet.open 'data/label_worx.xls'
worksheets = workbook.worksheets
ws = worksheets[0]
$catalog_current = ws.rows[1][1]
$price = 1.29

def getGenres(package)
    genres = package[0][13].to_s
    package.each do |genre|
        if genres != genre[13]
            genres = genres + "|#{genre[13]}"
            break
        end
    end
   return genres
end

def getYears(date1)
    tab = Array.new
    tab = date1.split('/')
    return tab[2]
end

def getPrice(package)
    price = 0
    package.each {|song| price = price + $price}
    return price.round(2)
end

def buildDataTrack(package)
    playlist = ""
    i = 1
    package.each do |son|
        playlist = son[8].nil? ? playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{son[1]}_#{i}.mp3\">#{son[6]} - #{son[7]}</a>\n" : playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{son[1]}_#{i}.mp3\">#{son[6]} - #{son[7]} (#{son[9]})</a>\n"
        i = i + 1
    end
    return playlist
end

def sendPackage(package,xml)
i = 1
    xml.release{
        xml.title package[0][3]
        xml.sku_ep package[0][1]
        xml.artists package[0][2]
        xml.label package[0][0]
        xml.genres getGenres(package)
        xml.years getYears(package[0][4])
        xml.type "release"
        xml.price getPrice(package)
        xml.description package[0][5]
        xml.owners "label_worx"
        xml.product_visibility "visible"
        xml.featured_image "https://www.aze.digital/wp-content/uploads/#{getYears(package[0][4])}/#{package[0][1]}"
        xml.download_file_name "#{package[0][2]} - #{package[0][3]} #{package[0][1]}.wav"
        xml.playlist_data buildDataTrack(package)
        
        package.each do |row|
            xml.post{
                xml.title row[4]
              
                xml.artists row[7]
                xml.label row[0]
            
            }
        end
    }
end

def test(ws,xml)
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


build_xml(ws)