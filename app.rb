require 'pp'
require_relative 'lib/builder'
require 'spreadsheet'
require 'nokogiri'

workbook = Spreadsheet.open 'data/label_worx.xls'
worksheets = workbook.worksheets
ws = worksheets[0]
$catalog_current = ws.rows[1][1]

def checkCurrentCatalog?(catalog)
    if catalog == nil
        return false
    end
    if $catalog_current == catalog
        return true
    else
        $catalog_current = catalog
        return false
    end
end



def sendPackage(package,xml)
    xml.release{
        package.each do |row|
            xml.title row[1]
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
=begin
worksheets[0].rows.each do |row|
    pp row[1]
    i = i + 1
end

def getYears(date1)
    tab = Array.new
    if date1
        tab = date1.split('/')
        return tab[2]
    end
end

def getPlaylist(ws)
    playlist = ""
    i = 1
    ws.rows.drop(1).each do |row|
        playlist = row[15].nil? ? playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{row[1]}_#{i}.mp3\">#{row[2]} - #{row[3]}</a>\n" : "no"
        i = 1 + i
    end
    return playlist
end
build_xml(worksheets[0])
=end