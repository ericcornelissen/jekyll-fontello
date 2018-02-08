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
  end

  def test_generate
    #
    generator = JekyllFontello::Generator.new

    #
    generator.generate(@site)
  end

  def test_download_zip
    @generator.download_zip()
  end

  def _test_extract_zip
    @generator.extract_zip(@site)
  end

  def test_set_font_path
    @generator.set_font_path()
  end

  def _test_clean_up
    @generator.clean_up()
  end

  def test_session_key
    refute_equal "", @generator.session_key
  end

  def test_relative_path_styles_to_fonts
    @generator.relative_path_styles_to_fonts
  end
end
