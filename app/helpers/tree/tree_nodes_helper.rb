 module Tree
  module TreeNodesHelper

    # Helper to get the breadcrumb for a category
    def get_breadcrumb_path cat_id
      # Find the document with the specific id
      doc = Finder.get_doc_by_id(cat_id)
      # add its own id in breadcrumb
      doc['bread_crumb_ssim'].nil? ? breadcrumb = [] : breadcrumb = doc['bread_crumb_ssim']
      # Get the array and revert the order
      return breadcrumb.reverse << cat_id
    end

    # Helper to get the siblings of a category
    def get_siblings cat_id
      # Find the document with the specific id
      doc = Finder.get_doc_by_id(cat_id)
      # Get the parent id
      parent = doc['parent_ssi']
      # Find the subcategories of this parent
      siblings = Finder.get_subcats_by_id(parent)
      return siblings
    end

    # Helper to get the
    def get_children cat_id
      # Find the subcategories of a specific id
      children = Finder.get_subcats_by_id(cat_id)
      return children
    end

  end
 end