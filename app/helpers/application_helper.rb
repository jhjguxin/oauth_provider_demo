module ApplicationHelper
  MARKDOWN_OPTIONS = { :autolink => true, :space_after_headers => true, :fenced_code_blocks => true }

  def add_params_to_url(url, path, params)
    if url.present? and params.present?
      uri = URI(url)
      query_hash = Rack::Utils.parse_query(uri.query)
      query_hash.merge!(params)
      #uri.query = Rack::Utils.build_query(query_hash) #cannot use to nest_hash
      uri.query = query_hash.to_param
      uri.path = path
      uri.to_s
    end
  end

  def api_test_url(path, param)
    if param.present?
      #url = "http://localhost:3000/commend/index?mkey=121b11ad5c24f5bb93e62f5acd8ebefd&language=1&log=3.0%2Cchannel%2Candroid%2C355031040249910%2C89860107000210127497%2Candroid%2C16%2CNexus+S%2C480x800%2C46001%2Ccn"
      url = "http://localhost:3000/"
      add_params_to_url(url, path, param)
    end
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(HTMLWithCoderay, MARKDOWN_OPTIONS)
    markdown.render(text).html_safe
  end

  def readme_to_markdown
    markdown(File.read(Rails.root + "README.md"))
  end
end
