class Listing < ActiveRecord::Base
  enum category: {
    'apartment': 0,
    'terrace': 1,
    'bungalow': 2,
    'villa': 3
  }


  filterrific(
  default_filter_params: { sorted_by: 'created_at_desc' },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_room_number,
    :with_bathroom_number
  ]
	)

scope :search_query, lambda { |query|
  return nil  if query.blank?
  terms = query.downcase.split(/\s+/)
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  num_or_conds = 3
  where(
    terms.map { |term|
      "(LOWER(listings.title) LIKE ? OR LOWER(listings.location) LIKE ? OR LOWER(listings.category) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}

	# (if working in next_academy, maybe ask someone how to refactor this part of the code).
  scope :sorted_by, lambda { |sort_key| 
  	if sort_key == 0 or sort_key == 1 or sort_key == 2 or sort_key == 3 
  		where(category: sort_key)
  	else
  		return nil
  	end 
 	}

  scope :with_room_number, lambda { |room_number| where('Listings.room_nums = ?', room_number) }
  scope :with_bathroom_number, lambda { |bathroom_number| where('Listings.bathroom_nums = ?', bathroom_number) }

  def self.options_for_sorted_by
    [	
      ['Everything', 'all'],
      ['Apartment', '0'],
      ['Terrace', '1'],
      ['Bungalow', '2'],
      ['Villa', '3']
    ]
  end


end
