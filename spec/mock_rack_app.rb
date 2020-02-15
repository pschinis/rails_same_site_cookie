class MockRackApp

  attr_reader :request_headers
  attr_accessor :cookie

  def initialize
    @request_headers = {}
    @cookie = "thiscookie=adjksjdksadskaljklddasmkl; "
  end

  def call(env)
    @env = env
    @set_cookie_header = env['HTTP_SET_COOKIE']
    [200, {'Content-Type' => 'text/plain', 'Set-Cookie' => @cookie}, ['OK']]
  end

  def [](key)
    @env[key]
  end

end
