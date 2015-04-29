module Service
  class Flickr
    def upload(image_path, file_name)
      links = { link:'http://farm9.staticflickr.com/8796/17306389125_7f60267c76_b.jpg',
                thumbnail:'http://farm9.staticflickr.com/8796/17306389125_7f60267c76_t.jpg',
                medium:'http://farm9.staticflickr.com/8796/17306389125_7f60267c76_z.jpg',
                small:'http://farm9.staticflickr.com/8796/17306389125_7f60267c76_n.jpg',
                title: 'Carlos_Marighella.jpg'}

      links.inject({}) do |hash, (key,value)|
        hash[key] = value.gsub('https://','http://')
        hash
      end
    end
  end
end