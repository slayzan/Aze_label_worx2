def build_xml(ws)
    i = 0
    j = 0
    builder = Nokogiri::XML::Builder.new do |xml|
       xml.data{
           test(ws,xml)
       }
    end
        File.open("data/output.xml", 'w'){ |f| f.write(builder.to_xml)}
end