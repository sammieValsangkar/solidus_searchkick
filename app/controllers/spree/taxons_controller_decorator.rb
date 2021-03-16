Spree::TaxonsController.class_eval do
  def autocomplete
    keywords = params[:keywords] ||= nil
    json = Spree::Taxon.autocomplete(keywords)
    render json: json
  end
end
