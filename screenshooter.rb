require 'sinatra'
require 'yaml'
require 'aws/s3'

DIR = File.expand_path(File.dirname(__FILE__))
SAVE_DIR = "#{DIR}/public/images/"
JS_PATH = "#{DIR}/screenshooter.js"

configure do
  set :config, YAML.load_file('screenshooter.yml')
end

get '/' do
  uri = URI.parse(params[:url])
  ds = settings.config['domains']
  return "" unless ds.nil? || ds.size == 0 || ds.map{|d| /#{d}/.match(uri.host)}.compact.size > 0

  png_file = "#{uri.host}#{uri.path.gsub('/', '__')}.png"
  shoot png_file
  resize png_file
  upload png_file
end

def shoot(png_file)
  url = params[:url] + (params[:hb] || '')
  clip = params[:clip] ? "clip==#{params[:clip]}" : ''
  `phantomjs #{JS_PATH} url=='#{url}' filename==#{SAVE_DIR}#{png_file} #{clip}`
end

def resize(png_file)
  if params[:resizewidth] && params[:resizeheight]
    `convert #{SAVE_DIR}#{png_file} -resize #{params[:resizewidth]}x#{params[:resizeheight]} #{SAVE_DIR}#{png_file}`
  elsif params[:resizewidth]
    `convert #{SAVE_DIR}#{png_file} -resize #{params[:resizewidth]} #{SAVE_DIR}#{png_file}`
  end
end

def upload(png_file)
  AWS::S3::Base.establish_connection!(:access_key_id => settings.config['s3_access_key_id'], :secret_access_key => settings.config['s3_secret_access_key'])

  s3_files = [png_file.gsub('__', '/')]
  s3_files << s3_files.first.gsub(".png", "-#{Time.now.strftime("%Y%m%d%H%M%S%L")}.png") if params[:timestamp] == 'true'
  s3_files.each do |s3_file|
    AWS::S3::S3Object.store("screenshooter/#{s3_file}", open("#{SAVE_DIR}#{png_file}"), settings.config['s3_bucket'], :access => :public_read, 'Cache-Control' => (params[:cachetime] ? "public, max-age=#{params[:cachetime]}" : ''))
  end

  url = "http://#{settings.config['s3_bucket']}.s3.amazonaws.com/screenshooter/#{s3_files.last}"
  params[:callback] ? "#{params[:callback]}('#{url}');" : url
end
