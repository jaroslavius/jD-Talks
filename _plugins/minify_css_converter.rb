module Jekyll
  # Compresses CSS using the YUI compressor and Jammit.
  # Inside css you must specify an empty YAML header:
  # ---
  # ---
  # .your_code {
  # }
  # .css -> .min.css
  class CssMinifierConverter < Converter
    def init
      return if @init
      require 'yui/compressor'
      require 'jammit'
      @init = true
    rescue LoadError
      STDERR.puts 'Missing libraries required for minifier. Please run:'
      STDERR.puts 'gem install yui-compressor jammit'
      raise FatalException.new('Missing dependency: yui-compressor with jammit')
    end
    def matches(ext)
      ext =~ /css/i
    end
    def output_ext(ext)
      '.min.css'
    end
    def convert(content)
      init
      YUI::CssCompressor.new(Jammit.css_compressor_options || {}).compress(content)
    end
  end
end
