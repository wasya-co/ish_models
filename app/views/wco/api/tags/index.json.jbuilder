
json.tags do
  json.array! @tags do |tag|
    json.label tag.to_s
    json.value tag.id.to_s
  end
end
