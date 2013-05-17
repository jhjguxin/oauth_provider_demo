require 'net/http'
require 'net/https'
require 'json'
require "base64"
require 'tempfile'
#about base64 encode
#http://www.ruby-doc.org/stdlib-1.9.3/libdoc/base64/rdoc/Base64.html


module Http
  class ActionWrap
    def initialize(request_adress = {url: "http://localhost"})
      begin
        url = request_adress[:url]
        @request_uri = URI request_adress[:url]
      rescue
        raise "invalid url #{url}"
      end
    end

    def set_headers(param = {use_gzip: true,use_form_data: false, header: {}})
      headers = {
                   "Accept" => "text/html,application/json, text/javascript, */*; q=0.01;q=0.9,*/*;q=0.8",
                   "Accept-Charset" => "utf-8;q=0.7,*;q=0.3"#,
                   #"Accept-Language" => "en-US,en;q=0.8"
                }

      if param.present?
        #if param.delete(:use_gzip)
        #if no use_gzip give will use gzip with default
        if param[:use_gzip].nil? or param.delete(:use_gzip)
          #If initheader doesn't have the key 'accept-encoding', then a value of "gzip;q=1.0,deflate;q=0.6,identity;q=0.3" is used, so that gzip compression is used in preference to deflate compression, which is used in preference to no compression
          #headers.reverse_merge({"Accept-Encoding" => "gzip,deflate"})
          headers.merge!({"Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"})
        end
        if param.delete(:use_form_data)
          headers.merge!({"Content-type" => "application/x-www-form-urlencoded"})
        end
        if (header = param.delete(:header)).present?
          headers.merge!(header) if header.is_a? Hash
        end
      end
      headers
    end
    #http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
    def uri(path,param={},use_ssl)
      u = @request_uri
      query_hash = Rack::Utils.parse_query(u.query).reverse_merge(param)
      u.path = path
      u.query = query_hash.to_param
      u
    end

    #get({path: "/",param: {}}, data={}, extra_param = {use_ssl: false, headers: {use_gzip: true, use_form_data: false, header: {}}})
    def get(nomal_param = {path: "",param: {}}, data={}, extra_param = {use_ssl: false, headers: {use_gzip: true, use_form_data: false, header: {}}})

      use_ssl = extra_param[:use_ssl].nil? ? false : extra_param.delete(:use_ssl)
      headers = extra_param[:headers].nil? ? {} : extra_param.delete(:headers)

      path = nomal_param[:path] || @request_uri.path
      param = nomal_param[:param] || {}

      u = uri(path, param, use_ssl)
      http = Net::HTTP.new(u.host, u.port)

      request = Net::HTTP::Get.new(u.request_uri, set_headers(headers))

      if use_ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      #response = Net::HTTP.get uri(path, param) #can only return some string
      #response = http.request(request)

      begin
        Net::HTTP.start(u.host, u.port) do |http|
          request = Net::HTTP::Get.new u.request_uri

          response = http.request request # Net::HTTPResponse object

          response.body
        end
      rescue => e
        {error: e.message}
      end
    end

    # when upload a file you should set 'multipart' as true
    def post(nomal_param = {path: "",param: {}}, data={}, extra_param = {use_ssl: false, multipart: false, headers: {use_gzip: true, use_form_data: true, header: {}}})

      use_ssl = extra_param[:use_ssl].nil? ? false : extra_param.delete(:use_ssl)
      headers = extra_param[:headers].nil? ? {} : extra_param.delete(:headers)
      multipart = extra_param[:multipart].nil? ? false : extra_param.delete(:multipart)
      path = nomal_param[:path] || @request_uri.request_uri
      param = nomal_param[:param] || {}

      u = uri(path, param, use_ssl)
      http = Net::HTTP.new(u.host, u.port)

      request = Net::HTTP::Post.new(u.request_uri, set_headers(headers))

      # covert_pic64_to_pic it will work with set_form
      # set_form # File net/http.rb, line 1796
      data = covert_pic64_to_pic(data)

##################################################
#To send multipart/form-data use Net::HTTPGenericRequest#body= and #Net::HTTPHeader#content_type=:
#   req = Net::HTTP::Post.new(uri.path)
#   req.body = multipart_data
#   req.content_type = 'multipart/form-data'
#   Other requests that can contain a body such as PUT can be created in the same way using the corresponding request class (Net::HTTP::Put).
#################################

      if multipart
        # enctype is the type to encode the form data set. It is application/x-www-form-urlencoded or multipart/form-data
        request.set_form(data, enctype='multipart/form-data', formopt={})
      else
        # set_form_data Also aliased as: form_data=
        request.set_form_data data
      end

      #if use_ssl
      #  http.use_ssl = true
      #  http.verify_mode = OpenSSL::SSL::VERIFY_NONE #not work
      #end

      #response = Net::HTTP.post_form(uri(path, param), data) #can only return some string
      response = http.request(request)
      response.body
      #####
      #destroy_tmpfile(data[:pic])

=begin
begin
  Net::HTTP.start(u.host, u.port) do |http|
    request = Net::HTTP::Post.new u.request_uri

    response = http.request request # Net::HTTPResponse object
    response.body
  end
rescue => e
  {error: e.message}
end
=end
    end

    private
    def unpack_data(body)
      s = StringIO.new
      s << body
      s.rewind
      s.read
    end

    def try_unpack_gzip(body)
      #http://stackoverflow.com/questions/1361892/how-to-decompress-gzip-string-in-ruby
      #Zlib::GzipReader.new(StringIO.new(http.request(request).body)).read
      if body.present? and body.encoding.to_s.eql? "ASCII-8BIT"
        Zlib::GzipReader.new(StringIO.new(body)).read
      else
        body
      end
    end
    def covert_pic64_to_pic(data)
      if data.has_key? :pic64 and (str = data.delete(:pic64))
        file = covert_base64_to_file(str)
        data.merge!({pic: file})
      else
        data
      end
    end
    def covert_base64_to_file(str = "")
      if str.present?
        binary_str = Base64.decode64(str)
        #file = File.open("tmp.jpg","wb"){|f| f.write(binary_str)}
        file = Tempfile.new(['tmp', '.jpg'], :encoding => 'ascii-8bit')
        file.write(binary_str)
        file.rewind
        file
      end
    end
    def destroy_tmpfile(file)
      if file.present? and file.is_a? Tempfile
        file.close
        file.unlink
      end
    end
  end
end
=begin
action_wrap = Http::ActionWrap.new({url: "http://www.baidu.com"})
action_wrap.get()

uri = URI('http://www.baidu.com/index.html')
params = { :limit => 10, :page => 3 }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
puts res.body if res.is_a?(Net::HTTPSuccess)

uri = URI('http://example.com/some_path?query=string')

Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri.request_uri

  response = http.request request # Net::HTTPResponse object
  puts response.body
end
=end
