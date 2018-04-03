json.array! @tracks do |track|
  json.(track, :id, :name)
end
