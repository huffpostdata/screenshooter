require 'sinatra'
require 'yaml'
require 'aws/s3'

DIR = File.expand_path(File.dirname(__FILE__))
SAVE_DIR = "#{DIR}/public/images/"
JS_PATH = "#{DIR}/screenshooter.js"

get '/' do
  uri = URI.parse(params[:url])
  png_file = "#{uri.host}#{uri.path.gsub('/', '__')}.png"
  shoot png_file
  resize png_file
  upload png_file
end

def shoot(png_file)
  `#{Sinatra::Application.environment == :production ? 'xvfb-run ' : ''}phantomjs #{JS_PATH} #{params[:url]} #{SAVE_DIR}#{png_file}`
end

def resize(png_file)
  if params[:width] && params[:height]
    `convert #{SAVE_DIR}#{png_file} -resize #{params[:width]}x#{params[:height]} #{SAVE_DIR}#{png_file}`
  elsif params[:width]
    `convert #{SAVE_DIR}#{png_file} -resize #{params[:width]} #{SAVE_DIR}#{png_file}`
  end
end

def upload(png_file)
  s3_config = YAML.load_file('s3.yml')
  AWS::S3::Base.establish_connection!(:access_key_id => s3_config['access_key_id'], :secret_access_key => s3_config['secret_access_key'])
  AWS::S3::S3Object.store("screenshooter/#{png_file.gsub('__', '/')}", open("#{SAVE_DIR}#{png_file}"), s3_config['bucket'], :access => :public_read, 'Cache-Control' => "public, max-age=60")
  "http://#{s3_config['bucket']}.s3.amazonaws.com/screenshooter/#{png_file.gsub('__', '/')}"
end
