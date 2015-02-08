class ProfileParserService

    # @param [String] url
    def initialize(url)
        @page = Nokogiri::HTML(RestClient.get(replace_url url).to_s)
    end

    # Parses the html and builds an Athlete object
    # @return [Athlete]
    def parse
        # parse current page
        results = parse_page @page

        # parse other years
        years_anchors = @page.xpath('//a[contains(@href, "profil.php?year=")]')
        years_anchors.each { |anchor|
            results.concat parse_year(anchor.attribute('href').content)
        }

        return results
    end

    # @param [String] url
    # @return [Array]
    def parse_year(url)
        page = Nokogiri::HTML(RestClient.get(replace_url url).to_s)
        parse_page page
    end

    # Parses a given page
    # @param [Nokogiri] page
    # @return [Array]
    def parse_page(page)
        # array of hashes for storing results
        results = []

        # we only want the noted results for this year
        tables = page.xpath('//table[@width="100%" and not(preceding-sibling::*[text()="Årsbedste:"])]')
        tables.each { |table|

            rows = table.xpath('tr')
            discipline = rows[0].xpath('td')[0].content.sub ':', ''

            i = 0
            rows.each { |row|

                if i > 1
                    value = row.xpath('td')[0].content.strip
                    competition_anchor = row.xpath('td/a')[0]
                    competition_id = competition_anchor.attribute('href').content.sub 'event.php?id=', ''
                    competition_name = competition_anchor.content
                    date = row.xpath('td')[2].content.strip
                    association = row.xpath('td')[3].content.strip

                    results.push(
                        {
                            :discpline => discipline,
                            :value => value,
                            :competition_id => competition_id,
                            :competition_name => competition_name,
                            :date => date,
                            :association => association
                        }
                    )
                end
                i += 1
            }
        }

        return results
    end

    def replace_url(url)
        unless url.start_with? 'http://s'
            'http://statletik.dk/' + url
        else
            url
        end
    end

    private :parse_page, :parse_year, :replace_url
end