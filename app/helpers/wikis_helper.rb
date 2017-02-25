module WikisHelper
  def privacy_update
    @wikis = Wiki.all

    @wikis.each do |wiki|
      wiki.update_attributes(private: false) if wiki.user.standard?
    end
  end
end
