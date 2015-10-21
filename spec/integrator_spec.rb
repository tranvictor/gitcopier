require 'gitcopier'

RSpec.describe Gitcopier::Integrator do
  before :each do
    allow_any_instance_of(Gitcopier::Decisions).to(
      receive(:get_data_from_file).and_return(
      %({
            "clicklion/src/assets/js/libs/something.coffee": {
              "decision": "y",
              "source": "clicklion/src/assets/js/libs/something.coffee",
              "des": "rspec/destination/something.coffee"
            },
            "clicklion/src/assets/css/": {
              "decision": "y",
              "source": "clicklion/src/assets/css/",
              "des": "rspec/destination/"
            },
            "clicklion/src/assets/img/" : {
              "decision": "n",
              "source": "clicklion/src/assets/img/",
              "des": "rspec/destination/"
            },
            "clicklion/src/assets/follow/" : {
              "decision": "enter",
              "source": "clicklion/src/assets/follow/",
              "des": "rspec/destination/"
            }
          }
       )))
    @integrator = described_class.new(Dir.pwd + "/", "root/path/")
  end

  describe "#changed_files" do
    it "returns list of changed file for the last pull" do
      allow(@integrator).to receive(:commit_log).and_return(%(
        commit 7e95e2007b9eaf0ee7301f548987fd62206d48ce
        Author: Gia <gia@coa.vn>
        Date:   Mon Oct 19 15:47:00 2015 +0700

            dashboard.styl + advertiser.js + publisher.js + highcharts.theme.js

        M	clicklion/src/assets/css/layouts/dashboard.styl
        M	clicklion/src/assets/css/layouts/home.styl
        M	clicklion/src/assets/data/all-domain-geo-data.json
        M	clicklion/src/assets/js/dashboard/advertiser.coffee
        M	clicklion/src/assets/js/dashboard/publisher.coffee
        M	clicklion/src/assets/js/libs/highcharts.theme.coffee
        M	clicklion/src/dashboard/index.jade
        A	clicklion/src/img/home/f-content.png
        A	clicklion/src/img/home/f-report.png
        A	clicklion/src/img/home/f-ux.png
        A	clicklion/src/img/home/f-visitor.png
        M	clicklion/src/pages/home.jade
      ))

      expect(@integrator.changed_files).to eq([
        'M	clicklion/src/assets/css/layouts/dashboard.styl',
        'M	clicklion/src/assets/css/layouts/home.styl',
        'M	clicklion/src/assets/data/all-domain-geo-data.json',
        'M	clicklion/src/assets/js/dashboard/advertiser.coffee',
        'M	clicklion/src/assets/js/dashboard/publisher.coffee',
        'M	clicklion/src/assets/js/libs/highcharts.theme.coffee',
        'M	clicklion/src/dashboard/index.jade',
        'A	clicklion/src/img/home/f-content.png',
        'A	clicklion/src/img/home/f-report.png',
        'A	clicklion/src/img/home/f-ux.png',
        'A	clicklion/src/img/home/f-visitor.png',
        'M	clicklion/src/pages/home.jade'
      ])
    end
  end

  describe "#integrate_all_changes" do

  end
end
