require 'pry'
Puppet::Type.type(:app_config).provide(:ruby) do
  desc 'Provider description'

  confine exists: '/opt/app/bin/app.exe'
  has_command(:app_cli, '/opt/app/bin/app.exe')

  # pruefen, ob die resource existiert.
  def exists?
    # binding.pry
    @result = app_cli('list').split(%r{\n}).grep(%r{^#{resource[:key]}})
    if @result.length > 1
      raise ParserError, 'found multiple config items found, please fix this'
    end
    return false if @result.empty?
    return true unless @result.empty?
  end

  # resource entfernen
  def destroy
    app_cli('rm', resource[:key])
  end

  # reosurce anlegen
  def create
    app_cli('set', resource[:key], resource[:value])
  end

  # getter - value auslesen
  def value
    @result[0].split[1]
  end

  # setter - value setzen
  def value=(_value)
    app_cli('set', resource[:key], resource[:value])
  end
end
