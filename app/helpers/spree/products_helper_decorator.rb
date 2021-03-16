Spree::ProductsHelper.module_eval do
  def cache_key_for_products
    count = @products.count
    hash = Digest::SHA1.hexdigest(params.to_json)
    most_recently_updated_product = @products.results.max_by(&:updated_at)
    max_updated_at = (most_recently_updated_product ? most_recently_updated_product.updated_at : Date.today).to_s(:number)
    "#{I18n.locale}/#{current_pricing_options.cache_key}/spree/products/all-#{params[:page]}-#{hash}-#{max_updated_at}-#{count}"
  end
end
