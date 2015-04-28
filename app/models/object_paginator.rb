class ObjectPaginator
  attr_reader :params

  def initialize(options = {})
    @collection = options[:collection]
    @params     = options[:params]
  end

  def json(serializer = nil)
    {
      json: objects,
      meta: metadata,
      each_serializer: serializer
    }
  end

  private

  def current_page
    params[:page] ? params[:page].to_i : 1
  end

  def metadata
    {
      per_page:     per_page,
      current_page: current_page,
      total_pages:  total_pages
    }
  end

  def objects
    @objects ||= Kaminari.paginate_array(@collection).page(current_page).per(
      per_page
    )
  end

  def per_page
    params[:per_page] ? params[:per_page].to_i : 10
  end

  def total_pages
    @total_pages ||= objects.try(:total_pages)
  end
end
