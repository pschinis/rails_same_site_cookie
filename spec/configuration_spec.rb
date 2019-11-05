RSpec.describe RailsSameSiteCookie::Configuration do
  it "sets user_agent_regex" do
    config = described_class.new
    config.user_agent_regex = /dsasdd/
    expect(config.user_agent_regex).to eq(/dsasdd/)
  end
end
