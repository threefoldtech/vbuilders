IMAGE_REGEX = /(.*)(.jpg$)|(.*)(.jpeg$)|(.*)(.svg$)|(.*)(.png$)/
DOC_REGEX = /(.*)(.md$)/

# MDBook fixer starting obj
class MDBook
    @images = Hash(String, ImageObj).new
    @links = Hash(String,LinkObj).new
    @docs = Hash(String,DocObj).new
    @errors = [MDBookError]

    def initialize(@path : String)
    end

    def fix
      _walk(@path)
      _docs_process()
      _images_process()
      _errors_add()
    end

    # walk over the paths recursive, find the markdown docs & images
    # will execute on the #TODO: name requirements (lower case, no spaces)
    # will make sure the name's are unique (per doc, or per image category)
    # all errors will be captured
    def _walk(path : String)
      # puts " - process dir: #{path}"
      d=Dir.open(path)
      d.each do |pathsub|
        fullpath = File.join([path,pathsub])
        m = pathsub.match(DOC_REGEX)
        if m
          puts " - doc: #{fullpath}"
          @docs[pathsub]=DocObj.new(fullpath)          
        end
        #check on images
        m = pathsub.match(IMAGE_REGEX)
        if m
          @images[pathsub]=ImageObj.new fullpath
          puts " - image: #{fullpath}"
        end
        if File.directory? fullpath
          if ! File.match?("\.*",pathsub)
            _walk fullpath
          end
        end
      end
    end

    #find all links in the doc
    #find all images in the doc, see they exist
    def _docs_process()
      puts " - process docs"
      @docs.each do |name,doc|
        doc.process(self)
      end
    end

    def _images_process()
      puts " - process images"
      @images.each do |name,image|
        image.process(self)
      end
    end    

    # return markdown doc which lists all the errors nicely formatted
    # this errors doc will be added to the summary.md if exists at end !
    def _errors_add()
      #TODO: implement _errors_add
    end

  end

