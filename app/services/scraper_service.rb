class ScraperService

    # @param [String] url
    def initialize(url)
        html = RestClient.get(url).to_str
        @page = Nokogiri::HTML(html, nil, 'utf-8')
    end

    #def self.download_tmp_contents(url)
    #    html = RestClient.get(url).to_str
    #    filename = __dir__ + '/../../tmp/' + Time.now.strftime('%Y%m%d%H%M%S%L') + '.html'
    #    open(filename, 'w') { |f|
    #        f.puts html.force_encoding 'utf-8'
    #    }
    #    contents = open(filename, :encoding => 'utf-8').readlines
    #    File.delete filename
    #    return contents
    #end

    # @param [String] xpath
    # @return [Array]
    def get_links(xpath)
        anchors = @page.xpath(xpath)

        urls = []
        anchors.each { |anchor| urls.push anchor.attribute('href').content }

        return urls
    end
end