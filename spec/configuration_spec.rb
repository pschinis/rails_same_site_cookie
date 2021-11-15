RSpec.describe RailsSameSiteCookie::Configuration do
  it "sets user_agent_regex" do
    config = described_class.new
    config.user_agent_regex = /dsasdd/
    expect(config.user_agent_regex).to eq(/dsasdd/)
  end

  it "sets legacy cookie generation" do
    config = described_class.new
    config.user_agent_regex = true
    expect(config.user_agent_regex).to be_truthy
  end
end
