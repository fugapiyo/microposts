module UsersHelper
  def gravatar_for(user, options = {size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    image_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_url = user.image_url if user.image_url
    image_tag(image_url, alt: user.name, class: "gravatar")
  end
end
