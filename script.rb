require 'octokit'

# Замените следующие значения на свои
ACCESS_TOKEN = 'your_access_token'
REPO = 'username/repo'
BRANCH = 'main'

def upload_images_to_github(images)
  client = Octokit::Client.new(access_token: ACCESS_TOKEN)

  image_urls = images.map do |image|
    content = File.read(image, mode: 'rb')
    encoded_content = Base64.strict_encode64(content)

    begin
      filename = File.basename(image)
      client.contents(REPO, path: filename, query: {ref: BRANCH})
      client.update_contents(REPO, filename, "Update #{filename}", sha, branch: BRANCH, content: encoded_content)
    rescue Octokit::NotFound
      client.create_contents(REPO, filename, "Add #{filename}", encoded_content, branch: BRANCH)
    end

    "https://raw.githubusercontent.com/#{REPO}/#{BRANCH}/#{filename}"
  end

  image_urls
end

images = ['path/to/image1.png', 'path/to/image2.jpg']
urls = upload_images_to_github(images)
puts urls
