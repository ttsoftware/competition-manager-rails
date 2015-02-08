
namespace :scrape do

    desc 'scrape all profiles from statletik.dk'
    task :all => :environment do

        url = 'http://statletik.dk/profil.php?soeg=%25_%25'
        scraper = ScraperService.new url

        #links = scraper.get_links('//a[contains(@href, "profil.php?id=")]')
        #links.each { |link|
            #@parser = ProfileParserService.new link
            #results = @parser.parse
        #}
    end
end
