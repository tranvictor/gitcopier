require 'gitcopier'

describe Gitcopier::CommandLine, "#execute" do
  it "accepts options and trigger command accordingly to the option[:command]" do
    expect(described_class).to receive(:showall).once
    expect(described_class).to receive(:integrate).once
    described_class.execute({
      command: "showall"
    })
    described_class.execute({
      command: "integrate"
    })
  end
end

describe Gitcopier::CommandLine, '#validate' do
  it 'returns nil if --from or --to is nil' do
    expect(described_class.validate({
      command: 'integrate',
      from: File.expand_path(File.dirname(__FILE__)),
      to: nil
    })).to be nil
    expect(described_class.validate({
      command: 'integrate',
      from: nil,
      to: File.expand_path(File.dirname(__FILE__)),
    })).to be nil
  end

  it 'returns nil if --from doest exist or not under git control' do
    allow(described_class).to receive(:under_git_control?).and_return false
    expect(described_class.validate({
      command: 'integrate',
      from: File.expand_path(File.dirname(__FILE__)),
      to: File.expand_path(File.dirname(__FILE__)),
    })).to be nil
    RSpec::Mocks.space.proxy_for(described_class).reset
  end

  it 'return nil if --to doest exist' do
    allow(described_class).to receive(:exist?).and_return false
    expect(described_class.validate({
      command: 'integrate',
      from: File.expand_path(File.dirname(__FILE__)),
      to: File.expand_path(File.dirname(__FILE__)),
    })).to be nil
    RSpec::Mocks.space.proxy_for(described_class).reset
  end

  it 'removes trailing / from --from and --to' do
    allow(described_class).to receive(:under_git_control?).and_return true
    allow(described_class).to receive(:exist?).and_return true
    validated_options = described_class.validate({
      command: 'integrate',
      from: File.expand_path(File.dirname(__FILE__)) + "/",
      to: File.expand_path(File.dirname(__FILE__)) + "/",
    })
    expect(validated_options[:from][-1]).to_not eq "/"
    expect(validated_options[:to][-1]).to_not eq "/"
    RSpec::Mocks.space.proxy_for(described_class).reset
  end
end
