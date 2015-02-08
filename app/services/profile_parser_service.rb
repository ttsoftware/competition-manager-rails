
class ProfileParserService

    # @param [String] url
    def initialize(url)
        html = RestClient.get(replace_url url).to_str
        @page = Nokogiri::HTML(html, nil, 'utf-8')
        @gender = url[-1]
    end

    # Parses the html and builds an Athlete object
    # @return [Athlete]
    def parse

        @athlete_name = parse_athlete_name
        @athlete_birth_year = parse_athlete_birth_year

        # parse current page
        results = parse_page @page

        # parse other years
        years_anchors = @page.xpath('//a[contains(@href, "profil.php?year=")]')
        years_anchors.each { |anchor|
            results.concat parse_year(anchor.attribute('href').content)
        }

        return results
    end

    # @return [String]
    def parse_athlete_name
        athlete_tag = @page.xpath('//span[@class="tekst16b"]')[0].content
        return athlete_tag[/[^\d]+(?=-)/u].strip
    end

    # @return [String]
    def parse_athlete_birth_year
        athlete_tag = @page.xpath('//span[@class="tekst16b"]')[0].content
        return athlete_tag[/-.+-/u].gsub('-', '').strip
    end

    # @param [String] url
    # @return [Array]
    def parse_year(url)
        page = Nokogiri::HTML(RestClient.get(replace_url url).to_str, nil, 'utf-8')
        parse_page page
    end

    # Parses a given page
    # @param [Nokogiri] page
    # @return [Array]
    def parse_page(page)

        # get current year
        page_year = page.xpath('//b')[0].content.to_i

        # if birth year is in fact an age group
        if @athlete_birth_year.length < 4
            age_group = @athlete_birth_year
        else
            age_group = @gender + (page_year).to_s
        end

        # array of hashes for storing results
        results = []

        # we only want the noted results for this year
        tables = page.xpath('//table[@width="100%" and not(preceding-sibling::*[text()="Årsbedste:"])]')
        tables.each { |table|

            rows = table.xpath('tr')
            discipline_name = rows[0].xpath('td')[0].content.sub ':', ''

            i = 0
            rows.each { |row|

                if i > 1
                    value = row.xpath('td')[0].content.strip
                    # result value, with wind separated
                    wind = value[/[\+\-][\d\.]+/].to_f
                    value = value[/[\d\.]+/].to_f

                    competition_anchor = row.xpath('td/a')[0]
                    statletik_id = competition_anchor.attribute('href').content.sub 'event.php?id=', ''
                    competition_name = competition_anchor.content
                    date = row.xpath('td')[2].content.strip
                    association_name = row.xpath('td')[3].content.strip

                    # find entities associated with this given entity
                    association = get_association association_name
                    competition = get_competition competition_name, statletik_id
                    athlete = get_athlete @athlete_name, @athlete_birth_year, association
                    discipline = get_discipline discipline_name, age_group

                    result = Result.new(
                        age_group: age_group,
                        discipline_name: discipline_name,
                        value: value,
                        wind: wind,
                        date: date,
                        competition_id: competition.id,
                        athlete_id: athlete.id,
                        discipline_id: discipline.id
                    )

                    begin
                        result.save!
                    rescue ActiveRecord::RecordNotUnique => e
                        pp result
                    end

                    results.push(result)
                end
                i += 1
            }
        }

        return results
    end

    def get_competition(name, statletik_id)

        competition = Competition.find_by competition_statletik_id: statletik_id

        if competition.nil?
            competition = Competition.new
            competition.name = name
            competition.competition_statletik_id = statletik_id
            competition.save!
        end

        return competition
    end

    def get_athlete(name, birth_year, association)

        athlete = Athlete.where(name: name, birth_year: birth_year).take

        if athlete.nil?
            athlete = Athlete.new
            athlete.is_group = @athlete_birth_year.length < 4
            athlete.name = name
            athlete.birth_year = birth_year.to_i
            athlete.association_id = association.id
            athlete.save!
        end

        return athlete
    end

    def get_discipline(name, age_group)

        discipline = Discipline.find_by name: name

        if discipline.nil?
            discipline = Discipline.new
            discipline.name = name
            discipline.age_group = age_group
            discipline.is_male = age_group[0] == 'm'
            discipline.is_indoor == name.include?('inde')
            discipline.save!
        end

        return discipline
    end

    def get_association(name)

        association = Association.find_by name: name

        if association.nil?
            association = Association.new
            association.name = name
            association.save!
        end

        return association
    end

    def replace_url(url)
        unless url.start_with? 'http://s'
            'http://statletik.dk/' + url
        else
            url
        end
    end

    private :parse_page,
            :parse_year,
            :replace_url,
            :get_competition,
            :get_athlete,
            :get_discipline,
            :get_association
end