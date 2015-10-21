require 'gitcopier'

RSpec.describe Gitcopier::DirTree do
  let(:files) do
    [
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
    ]
  end

  describe "#initialize" do
    it 'accepts changed file list to construct dir tree' do
      expect { described_class.new("/Users/victor/", files) }.not_to raise_error
    end
  end

  describe '#travel' do
    before(:each) { @dir_tree = described_class.new("/Users/victor/", files) }

    it 'raises exception if no block is given' do
      expect { @dir_tree.travel }.to raise_error(ArgumentError)
    end

    it 'skips current directory if the block returns non-nil value' do
      @visited = []
      @dir_tree.travel do |file|
        @visited << file
        next false
      end
      expect(@visited.size).to eq 1
      expect(@visited[0]).to eq "/"
    end

    it 'DFS-travel the tree and evaluate given block on each dir tree node' do
      @visited = []
      @dir_tree.travel do |file|
        @visited << file
        next nil
      end
      expect(@visited.size).to eq 26
    end
  end
end
