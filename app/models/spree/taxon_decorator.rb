Spree::Taxon.class_eval do
  # Run after initialization, allows us to process product_decorator from application before this
  Rails.application.config.after_initialize do
    # Check if searchkick_options have been set by the application using this gem
    # If they have, then do not initialize searchkick on the model. If they have not, then set the defaults
    searchkick index_name: "#{Rails.application.class.module_parent_name.parameterize.underscore}_spree_taxons_#{Rails.env}", word_start: [:name] unless Spree::Taxon.try(:searchkick_options)
  end

  def search_data
    json = {
      name: name,
      description: description,
      active: available?
    }

    json
  end

  def available?
    available_count.to_i > 0
  end

  def self.autocomplete(keywords)
    if keywords
      Searchkick.search(
        keywords,
        fields: ['name^5'],
        match: :word_start,
        limit: 10,
        # misspellings: { below: 3 },
        load: false,
        index_name: [ Spree::Taxon, Spree::Product ],
        indices_boost: {Spree::Taxon => 2, Spree::Product => 1},
        where: {_or: [{_type: "spree/product", active: true}, {_type: "spree/taxon", active: true}]},
      ).map(&:name).map(&:strip).uniq
    else
      Spree::Product.search(
        '*',
        index_name: [ Spree::Product, Spree::Taxon ],
        indices_boost: {Spree::Taxon => 2, Spree::Product => 1},
        where: {_or: [{_type: "spree/product", active: true}, {_type: "spree/taxon", active: true}]}
      ).map(&:name).map(&:strip).uniq
    end
  end
end
