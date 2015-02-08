class ScraperService

    # @param [String] url
    def initialize(url)
        @page = Nokogiri::HTML(RestClient.get(url).to_s)
    end

    # @param [String] xpath
    # @return [Array]
    def get_links(xpath)
        anchors = @page.xpath(xpath)

        urls = []
        anchors.each { |anchor| urls.push anchor.to_s }

        return urls
    end
end