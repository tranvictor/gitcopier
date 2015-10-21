require 'gitcopier'

RSpec.describe Gitcopier::Decisions do
  context "given a saved json data" do
    before :each do
      @decisions = described_class.new "source_path", "destination_path"
      allow(@decisions).to receive(:get_data_from_file).and_return(
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
      ))
    end

    describe "#load" do
      it "loads json from file and store to @decisions instance variable" do
        expect { @decisions.load }.not_to raise_error
      end
    end

    describe "#get" do
      it "get decision object from decision data by source" do
        @decisions.load
        decision = @decisions.get("clicklion/src/assets/js/libs/something.coffee")
        expect(decision).to be_a(Gitcopier::Decision)
        expect(decision.source).to eq(
          "clicklion/src/assets/js/libs/something.coffee")
      end
    end
  end
end
