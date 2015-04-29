require 'sinatra'
require 'sinatra/json'
require 'haml'

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin, content-type'
  headers['Access-Control-Allow-Credentials'] = 'true'
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  halt HTTP_STATUS_OK
end

get "/upload" do
  haml :upload
end

post "/upload" do
  begin
    path = Dir.mktmpdir('upload')
    file_name = params['myfile'][:filename]
    file_path = "#{path}/#{file_name}"


    File.open(file_path, "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    is_pdf = (File.extname(file_name).downcase == '.pdf')


    service =  is_pdf ? Service::GoogleDrive.new : Service::Flickr.new

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
