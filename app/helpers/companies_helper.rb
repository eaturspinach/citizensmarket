module CompaniesHelper
  
  def brand_name_list(company)
    total_brands = company.brand_names.size
    top_9_brands = company.brand_names[0..9].join(', ')
    if total_brands > 10
      top_9_brands + ", " + link_to("#{total_brands - 10} more brands...", '')
    else
      top_9_brands
    end
  end
  
end
