require "./mdbook"
# LINK_REGEX = /(\[[\.\w -\:]*\]$)(.md$)/
LINK_REGEX1 = /\[[\.\w -\:]*\]\(.+\)/
LINK_REGEX2 = /\[[\.\w -\:]*\]$/
# TODO: also need to match: <img src=img/3bot_wallet_4.png height="450"> #TODO:
R = [LINK_REGEX1,LINK_REGEX2]

class MDBookError
    @path = ""
    @message = ""
    @obj_not_found = ""
end

class LinkObj

    def initialize(@path : String)    
        pp path
    end
  
    def process(@mdbook : MDBook)
    end
  
  end
  
#represents a full blown markdown document
class DocObj
    @path_printed = false

    def initialize(@path : String)    
    end

    # will find all links and see if they are pointing to existing doc or image
    def process(@mdbook : MDBook)        
        File.read_lines(@path).each do |line|
            R.each do |regex|
                m = line.match(regex)
                if m
                    if ! @path_printed
                        puts " - link(s) found in: #{@path}"
                        @path_printed = true
                    end
                    puts "   - link: #{m[0]}"
                end
            end
        end
    end

    def processlink(link : LinkObj)
        #TODO: check link to image/doc exists, if not create error & attach error to MDBook obj
        #TODO: once the image/doc found put the right link to the path in (fixes links)
    end

  end

class ImageObj
    @size_x=0
    @size_y=0
    def initialize(@path : String)    
    end

    def process(@mdbook : MDBook)
    end

    # will resize image to reasonable size
    # the original image will be kept but will become $name.original.$ext (moved)
    # the new image will be in line with size as requested but no more than 1200x1200
    # keep aspect ratio
    def resize
        #TODO: implement resize of images (phase 2)
    end
  end

#TODO: doesn't work with multiple regexes on 1 line yet
## e.g. link: [linux](https://github.com/threefoldfoundation/info_threefold/blob/development/docs/wikieditors/installation_linux.md) or [macos](https://github.com/threefoldfoundation/info_threefold/blob/development/docs/