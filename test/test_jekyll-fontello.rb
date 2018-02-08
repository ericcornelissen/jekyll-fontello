require 'minitest/autorun'
require 'minitest/spec'

require 'jekyll'
require 'jekyll-fontello'

class JekyllFontelloTest < Minitest::Test
  def setup
    @generator = JekyllFontello::Generator.new

    # Create a Configuration and Site instance to be used
    config = Jekyll::Configuration.new
    config = config.read_config_file("#{Dir.pwd}/test/fixtures/_config.yml")
    @config = Jekyll::Configuration.from(config)
    @site = Jekyll::Site.new(@config)

    # Initialize the default generator
    @generator.init(@config['fontello'])

    # Make sure none of the created files exists
    File.delete(JekyllFontello::SESSION_FILE) if File.exist? JekyllFontello::SESSION_FILE
    File.delete(JekyllFontello::ZIP_FILE) if File.exist? JekyllFontello::ZIP_FILE
  end

  def test_download_zip
    @generator.download_zip()
    assert File.exist? JekyllFontello::ZIP_FILE
  end

  def test_extract_zip
    FileUtils.cp('test/fixtures/fontello.zip', JekyllFontello::ZIP_FILE)
    @generator.extract_zip(@site)

    # Make sure the fonts are extracted
    assert File.exist? 'test/_tmp/fonts/fontello.eot'
    assert File.exist? 'test/_tmp/fonts/fontello.svg'
    assert File.exist? 'test/_tmp/fonts/fontello.ttf'
    assert File.exist? 'test/_tmp/fonts/fontello.woff'
    assert File.exist? 'test/_tmp/fonts/fontello.woff2'

    # Make sure the stylesheets are extracted
    assert File.exist? 'test/_tmp/styles/animation.css'
    assert File.exist? 'test/_tmp/styles/fontello-codes.css'
    assert File.exist? 'test/_tmp/styles/fontello-embedded.css'
    assert File.exist? 'test/_tmp/styles/fontello-ie7-codes.css'
    assert File.exist? 'test/_tmp/styles/fontello-ie7.css'
    assert File.exist? 'test/_tmp/styles/fontello.css'
  end

  def test_set_font_path
    FileUtils.cp('test/fixtures/stylesheet.css', 'test/_tmp/styles/stylesheet.css')
    @generator.set_font_path()
    assert_equal '@font-face { src: url(\'../foo/bar/fontello.eot?52513028\'); }',
      File.read('test/_tmp/styles/stylesheet.css')
  end

  def test_clean_up
    FileUtils.cp('test/fixtures/fontello.zip', JekyllFontello::ZIP_FILE)
    @generator.clean_up()
    refute File.exist? JekyllFontello::ZIP_FILE
  end

  def test_session_key
    # Make sure there is a session key
    session_key = @generator.session_key
    refute_equal "", session_key
    refute_nil session_key

    # Make sure the same session is returned
    assert_equal session_key, @generator.session_key

    # Make sure a new session_key is requested if the previous one is lost
    File.delete(JekyllFontello::SESSION_FILE)
    refute_equal session_key, @generator.session_key
  end

  def test_relative_path_styles_to_fonts
    # From fixtures/_config.yml, the relative path between
    # 'test/_tmp/fonts' and 'test/_tmp/styles' is '../fonts'.
    assert_equal Pathname.new("../fonts"), @generator.relative_path_styles_to_fonts
  end
end
