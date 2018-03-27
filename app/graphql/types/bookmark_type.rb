Types::BookmarkType = GraphQL::ObjectType.define do
  name "Bookmark"
  description "A pinnable bookmark, i.e., a named URL"
  field :id, !types.ID
  field :name, !types.String
  field :url, !types.String
  field :tags, types[Types::TagType]
end
