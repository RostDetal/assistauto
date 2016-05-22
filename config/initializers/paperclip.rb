module Paperclip
  class MediaTypeSpoofDetector
    def type_from_file_command
      begin
        Paperclip.run("file", "-b --mime :file", :file => @file.path)
      rescue Cocaine::CommandLineError
        ""
      end
    end
  end
end

# Paperclip.options[:content_type_mappings] = {
#     :jpg => "image/jpeg",
#     :jpeg => "image/jpeg",
#     :png => "image/png",
#     :gif => "image/gif",
# }