require 'rails_helper'
require 'webmock/rspec'

describe ProfileParserService, :type => :class do

    before :each do

        url = 'http://statletik.dk/profil.php?id=9333&sex=m'

        stub_request(:get, url)
            .with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'})
            .to_return(
                :status => 200,
                :body => open(__dir__ + '/../html/profil.html', 'r').readlines,
                :headers => {}
            )

        @parser = ProfileParserService.new url
    end

    describe '#parse' do
        it 'builds results objects' do

            # one stub for each year
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2008').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2008.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2009').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2009.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2010').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2010.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2011').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2011.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2012').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2012.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2013').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2013.html', 'r').readlines, :headers => {})
            stub_request(:get, 'http://statletik.dk/profil.php?id=9333&sex=m&year=2014').
                with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'}).
                to_return(:status => 200, :body => open(__dir__ + '/../html/profil_2014.html', 'r').readlines, :headers => {})

            results = @parser.parse
            expect(results.size).to eq 151
        end

        it 'correctly parses utf8' do
            url = 'http://statletik.dk/profil.php?id=10399&sex=m'
            stub_request(:get, url)
                .with(:headers => {'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby'})
                .to_return(
                    :status => 200,
                    :body => open(__dir__ + '/../html/profil_iso-8859-1.html', 'r').readlines,
                    :headers => {}
                )

            parser = ProfileParserService.new url

            name = parser.parse_athlete_name
            birth_year = parser.parse_athlete_birth_year

            expect(name).to eq 'Adams Jørgensen'
            expect(birth_year.to_i).to eq 1997
        end
    end
end