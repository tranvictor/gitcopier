require 'gitcopier'

describe Gitcopier::Decision, "#initialize" do
  context "with decision, source and destination given" do
    it "save and construct decision instance" do
      expect do
        described_class.new(
        "y", "clicklion/src/assets/js/libs/something",
        "/Users/victor/click_lion/app/assets/javascript/libs/somgthing")
      end.not_to raise_error

    end
  end
end

describe Gitcopier::Decision, "#is_copy?" do
  context "with given decision of y" do
    it "returns true" do
      expect(described_class.new("y", "source", "des").is_copy?).to be true
    end
  end
  context "with not y decision" do
    it "returns false" do
      expect(described_class.new("n", "source", "des").is_copy?).to be false
    end
  end
end

describe Gitcopier::Decision, "#is_follow?" do
  context "with given decision of not y nor n" do
    it "returns true" do
      expect(described_class.new("\n", "source", "des").is_follow?).to be true
    end
  end
  context "with given decision of y or n" do
    it "returns false" do
      expect(described_class.new("y", "source", "des").is_follow?).to be false
      expect(described_class.new("n", "source", "des").is_follow?).to be false
    end
  end
end

describe Gitcopier::Decision, "#is_not_copy?" do
  context "with given decision of n" do
    it "returns true" do
      expect(described_class.new("n", "source", "des").is_not_copy?).to be true
    end
  end
  context "with given decision of not n" do
    it "returns false" do
      expect(described_class.new("y", "source", "des").is_not_copy?).to be false
    end
  end
end

describe Gitcopier::Decision, "#source" do
  it "returns the source file" do
    decision = described_class.new("y", "source", "des")
    expect(decision.source).to eq "source"
  end
end

describe Gitcopier::Decision, "#des" do
  it "returns the des file" do
    decision = described_class.new("y", "source", "des")
    expect(decision.des).to eq "des"
  end
end
