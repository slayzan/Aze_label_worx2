def build_xml(ws)
    i = 1
    builder = Nokogiri::XML::Builder.new do |xml|
        xml.data{
            xml.post{
                xml.title ws.rows[1][3]
                xml.sku ws.rows[1][1]
                xml.slug ws.rows[1][1]
                xml.artists ws.rows[1][2]
                xml.label ws.rows[1][0]
                genres = ws.rows[1][13]
                genres["-"]="|"
                xml.genres genres
                xml.years  getYears(ws.rows[1][4])
                xml.type "release"
                xml.description ws.rows[1][5]
                xml.owners "label worx"
                xml.product_visibility "visible"
                xml.featured_image "https://www.aze.digital/wp-content/uploads/#{getYears(row[1][4])}/#{row[1][1]}.jpg"
            }
            ws.rows.drop(1).each do |row|
                xml.post{
                    xml.label_name row[0]
                    xml.sku "#{row[1]}_#{i}"
                    xml.title_release row[3]
                    xml.release_date row[4]
                    xml.description row[5]
                    xml.track_artist row[6]
                    xml.track_title row[7]
                    xml.remixer row[8]
                    xml.mix_name row[9]
                    xml.genres row[13]
                    xml.other_artist row[15]
                    xml.written_by row[16]
                    xml.produced_by row[17]
                    xml.publisher row[18]
                    xml.c_line row[19]
                    xml.p_line row[20]
                    xml.price 1.29
                    xml.featured_image "https://www.aze.digital/wp-content/uploads/#{getYears(row[4])}/#{row[1]}.jpg"
                   # xml.playlist_data !row[15] ? "<a href=\"http:\/\/player.yoyaku.io/mp3/#{row[1]}_#{i}.mp3\">#{row[2]} - #{row[9]}</a>" : "dfsf"
                   pp row[15].nil?
                    i = i + 1
                }
            end
           # xml.playlist_data $playlistData
        }
    end
        File.open("output.xml", 'w'){ |f| f.write(builder.to_xml)}
end