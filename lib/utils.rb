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

# Build the full data track for the release
def buildDataTrack(package)
    playlist = ""
    i = 1
    package.each do |son|
        playlist = son[8].nil? ? playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{son[1]}_#{i}.mp3\">#{son[6]} - #{son[7]}</a>\n" : playlist + "<a href=\"http:\/\/player.yoyaku.io/mp3/#{son[1]}_#{i}.mp3\">#{son[6]} - #{son[7]} (#{son[9]})</a>\n"
        i = i + 1
    end
    return playlist
end
