require 'rails_helper'
require 'webmock/rspec'

describe ScraperService, :type => :class do

    before :each do

        url = 'http://statletik.html/profil.php?soeg=%25_%25'

        # stub the request
        stub_request(:get, url)
            .with(
                :headers => {
                    'Accept' => '*/*; q=0.5, application/xml',
                    'Accept-Encoding' => 'gzip, deflate',
                    'User-Agent' => 'Ruby'}
            )
            .to_return(
                :status => 200,
                :body => open(__dir__ + '/../../html/statletik.html', 'r').readlines,
                :headers => {}
            )

        @scraper = ScraperService.new url
    end

    describe '#get_links' do
        it 'returns all anchors on page' do

            xpath = '//a[contains(@href, "profil.php?id=")]'
            links = @scraper.get_links(xpath)

            expect(links).to be_an_instance_of Array
            expect(links.size).to eq 11319
        end
    end
end