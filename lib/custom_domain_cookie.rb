class CustomDomainCookie
  def initialize(app)
    puts "----------------init cutom domain now #{app.inspect}"
    @app = app
    @default_domain = ".mystory.cc"
  end

  def call(env)
    puts "------call now #{env["HTTP_HOST"]}"
    host = env["HTTP_HOST"].split(':').first
    puts "------host = #{host}"
    env["rack.session.options"][:domain] = custom_domain?(host) ? ".#{host}" : "#{@default_domain}"
    puts "------env[\"rack.session.options\"][:domain] = #{env["rack.session.options"][:domain]}"
    @app.call(env)
  end

  def custom_domain?(host)
    host !~ /#{@default_domain.sub(/^\./, '')}/i
  end
end