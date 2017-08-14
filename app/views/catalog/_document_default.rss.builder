xml.item do  
  xml.title(index_presenter(document).label(document_show_link_field(document)) || (document.to_semantic_values[:title].first if document.to_semantic_values.key?(:title)))
  xml.link("http://www.kb.dk#{document.id}/#{params[:locale]}/")
  xml.author( document.to_semantic_values[:author].first ) if document.to_semantic_values.key? :author
end
