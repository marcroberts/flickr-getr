class Task

  def initialize config, task
    @config = config
    @task = task
  end

  def run
    case @task['type']
    when 'set', 'album'

      page = 1
      more = true
      while more do
        more = self.fetch_set(@task['id'], page)
        page += 1
      end
    end
  end

  protected

    def fetch_set id, page
      opts = {
        photoset_id: @task['id'],
        page: page,
        per_page: 500,
        extras: 'date_taken,original_format',
        media: 'photo'
      }

      set = flickr.photosets.getPhotos(opts)

      set['photo'].each do |photo|
        save_image photo
      end

      print "Saved page #{page}\n" if @config['debug']

      return Integer(set['total']) > page * 500
    end

    def save_image photo
      filename = File.join(@task['path'], "#{photo['id']}.#{photo['originalformat']}")

      if File.exist?(filename)
        print "Skipping #{FlickRaw.url_o(photo)}\n" if @config['debug']
      else
        print "Saving #{FlickRaw.url_o(photo)}\n" if @config['debug']

        date = Time.parse(photo['datetaken'])

        File.open(filename, 'w') do |file|
          file.binmode
          file.write(open(FlickRaw.url_o(photo)).read)
        end

        File.utime(date, date, filename)

      end
    end
end
