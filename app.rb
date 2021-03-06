require 'sinatra'
require 'sinatra/json'
require 'haml'
require 'mime-types'

require_relative 'lib/flickr.rb'
require_relative 'lib/google_drive.rb'
use Rack::MethodOverride

HTTP_STATUS_OK = 200
HTTP_STATUS_OK_NO_CONTENT = 204

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin, content-type'
  headers['Access-Control-Allow-Credentials'] = 'true'
end

options '*' do
  response.headers['Allow'] = 'HEAD, GET, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  halt HTTP_STATUS_OK
end

get "/upload" do
  haml :upload
end

delete '/upload' do
  halt HTTP_STATUS_OK_NO_CONTENT
end

post "/upload" do
  begin
    path = Dir.mktmpdir('upload')
    file_name = params['myfile'][:filename]
    file_path = "#{path}/#{file_name}"


    File.open(file_path, "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end

    is_image = (MIME::Types.of(file_name).first.media_type == 'image')
    service =  is_image ? Service::Flickr.new() : Service::GoogleDrive.new()

    json(service.upload(file_path, file_name))
  rescue Exception => e
    return e.message
  end
end

get "/files" do
  service = Service::GoogleDrive.new
  @files = service.list
  haml :files
end
