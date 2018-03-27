Mutations::CreateBookmark = GraphQL::Relay::Mutation.define do
  name "CreateBookmark"
  return_field :bookmark, Types::BookmarkType

  input_field :name, !types.String
  input_field :url, !types.String
  input_field :tags, types[!types.String]

  resolve ->(obj, args, ctx) {
    bookmark = Bookmark.create!(
      name: args[:name],
      url: args[:url],
      tags: args[:tags]&.map { |t| Tag.where(name: t.strip).first_or_create! } || [],
    )
    return {
      bookmark: bookmark
    }
  }
end
