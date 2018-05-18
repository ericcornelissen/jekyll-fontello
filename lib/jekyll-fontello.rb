require 'net/http'
require 'uri'
require 'zip'

Zip.on_exists_proc = true

module JekyllFontello
  FONTELLO_URL = 'http://fontello.com'
  SESSION_FILE = "#{Dir.tmpdir}/jekyll_fontello_session"
  ZIP_FILE = "#{Dir.tmpdir}/jekyll_fontello.zip"

  class Generator < Jekyll::Generator
    # Read the plugin configuration and generate the
    # Fontello files based on that.
    #
    #  required by Jekyll
    def generate(site)
      plugin_config = site.config['fontello'] || { }
      init(plugin_config)

      # Main pipeline
      download_zip()
      extract_zip(site)
      set_font_path()
      clean_up()
    end

    # Initialize the Generator instance variables.
    def init(config)
      @download_tries = 0

      # Load configuration from _config.yml
      @config_file = config['config'] || 'fontello_config.json'
      @output_fonts = config['output_fonts']|| 'fontello/fonts'
      @output_styles = config['output_styles'] || 'fontello/styles'
      @fonts_path = config['fonts_path'] || relative_path_styles_to_fonts
      @preprocessor = config['preprocessor'] || 'none'

      # Read the configuration
      @fontello_config = File.read(@config_file)
    end

    # Downloads the zip file from Fontello based on
    # the local configuration.
    #
    #  see: https://github.com/fontello/fontello/#api-methods
    def download_zip()
      url = URI("#{FONTELLO_URL}/#{session_key}/get")
      response = Net::HTTP.get_response(url)

      if response.code != '200'
        raise 'can\'t connect to Fontello' if @download_tries == 3

        # Remove the session key so a new one is requested
        File.delete(SESSION_FILE)

        # And retry download
        @download_tries += 1
        download_zip()
      else
        File.write(ZIP_FILE, response.read_body, universal_newline: true)
      end
    end

    # Extract the zip file downloaded from Fontello.
    def extract_zip(site)
      Zip::File.open(ZIP_FILE) do |zipfile|
        # Create the output directories
        FileUtils.mkdir_p("#{@output_fonts}")
        FileUtils.mkdir_p("#{@output_styles}")

        # Extract the relevant files from the .zip
        zipfile.each do |file|
          filename = File.basename(file.name)
          case File.extname file.name
            when '.woff', '.svg', '.ttf', '.eot', '.woff2'
              site.static_files << Jekyll::StaticFile.new(site, site.source, @output_fonts, filename)
              file.extract("#{@output_fonts}/#{filename}")
            when '.css'
              case @preprocessor
                when 'none'
                  file.extract("#{@output_styles}/#{filename}")
                when 'less'
                  file.extract("#{@output_styles}/#{filename.sub('.css', '.less')}")
                when 'scss'
                  file.extract("#{@output_styles}/_#{filename.sub('.css', '.scss')}")
                else
                  raise "unknown preprocessor #{@preprocessor}, should be any of \"none\", \"less\" or \"scss\""
              end
          end
        end
      end
    end

    # Update the font paths present in the stylesheets
    # based on the output folders/configuration.
    def set_font_path()
      Dir.entries(@output_styles).each do |filename|
        next if filename =~ /^\.\.?$/
        filepath = "#{@output_styles}/#{filename}"

        text = File.read(filepath)
        new_text = text.gsub(/..\/font/, "#{@fonts_path}")
        File.write(filepath, new_text)
      end
    end

    # Clean up after the Generator.
    def clean_up()
      File.delete(ZIP_FILE)
    end

    # Get a session key from Fontello or a session key
    # acquired before.
    #
    #  see: https://github.com/fontello/fontello/#api-methods
    def session_key
      return File.read(SESSION_FILE) if File.exist? SESSION_FILE

      url = URI(FONTELLO_URL)
      boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW'

      # Setup a http connection with Fontello
      http = Net::HTTP.new url.host, url.port

      # Construct the request to get a session key
      request = Net::HTTP::Post.new url
      request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
      request["Content-Disposition"] = 'multipart/form-data'
      request["Cache-Control"] = 'no-cache'
      request.body = "--#{boundary}\r\nContent-Disposition: form-data; name=\"config\"; filename=\"#{@config_file}\"\r\nContent-Type: application/json\r\n\r\n#{@fontello_config}\r\n--#{boundary}--"

      # Send the request to Fontello
      response = http.request(request)

      # Store the session key for later use
      File.write(SESSION_FILE, response.read_body)
      return response.read_body
    end

    # Get the relative path between the fonts output
    # folder and the styles output folder.
    def relative_path_styles_to_fonts
      style_path = Pathname.new(@output_styles)
      fonts_path = Pathname.new(@output_fonts)
      return fonts_path.relative_path_from(style_path)
    end
  end
end
