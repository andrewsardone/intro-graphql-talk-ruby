# intro-graphql-talk-ruby

A simple bare-bones Rails app that was demoed at [the 2018-03-27 Ann Arbor Ruby
meetup][tweet] for the purposes of getting started with [the GraphQL Ruby
gem][gqlr].

[**Slides**](http://andrewsardone.com/presentations/2018-03-28.a2rb_introduction_to_graphql.pdf)

## Getting Started

Going commit-by-commit demonstrates how to install dependencies and scaffold
the GraphQL API for your own app. To run this app, having Docker is the easiest
route (e.g., [Docker for Mac](https://www.docker.com/docker-mac)). With
`docker-compose` you can get the app running via:

```bash
git clone https://github.com/andrewsardone/intro-graphql-talk-ruby
cd intro-graphql-talk-ruby
docker-compose build web
docker-compose run web bin/setup
docker-compose up
```

Visit the [GraphiQL] API explorer at https://localhost:3000/graphiql.

## Sample App

Inspired by [How to GraphQL's Ruby tutorial][htwql], the app is intended to be
a [Pinboard](https://pinboard.in)-style bookmark manager. There isn't any
browser user interface, but solely an exposed GraphQL API that's explorable via
[GraphiQL]:

<img src="https://www.dropbox.com/s/tzx1wdeq5ka6ii0/a2rb-graphiql-screenshot.png?raw=1" width="400" />

The model layer consists of bookmarks and tags:

```
shell> bin/rails console
pry(main)> show-models
ApplicationRecord
  Table doesn't exist
Bookmark
  id: integer
  name: string
  url: string
  created_at: datetime
  updated_at: datetime
  has_many :taggings
  has_many :tags (through :taggings)
Tag
  id: integer
  name: string
  created_at: datetime
  updated_at: datetime
  has_many :bookmarks (through :taggings)
  has_many :taggings
Tagging
  id: integer
  bookmark_id: integer
  tag_id: integer
  created_at: datetime
  updated_at: datetime
  belongs_to :bookmark
  belongs_to :tag
```

And our GraphQL API exposes those types:

```graphql
# A pinnable bookmark, i.e., a named URL
type Bookmark {
  id: ID!
  name: String!
  tags: [Tag]
  url: String!
}

# Autogenerated input type of CreateBookmark
input CreateBookmarkInput {
  # A unique identifier for the client performing the mutation.
  clientMutationId: String
  name: String!
  url: String!
  tags: [String!]
}

# Autogenerated return type of CreateBookmark
type CreateBookmarkPayload {
  bookmark: Bookmark

  # A unique identifier for the client performing the mutation.
  clientMutationId: String
}

type Mutation {
  createBookmark(input: CreateBookmarkInput!): CreateBookmarkPayload

  # An example field added by the generator
  testField: String
}

type Query {
  # A root collection of all Bookmarks
  bookmarks: [Bookmark]!

  # An example field added by the generator
  testField: String
}

type Tag {
  bookmarks: [Bookmark]
  id: ID!
  name: String!
}
```

[tweet]: https://twitter.com/a2rb/status/978670577853583360
[gqlr]: http://graphql-ruby.org/
[GraphiQL]: https://github.com/graphql/graphiql
[htwql]: https://www.howtographql.com/graphql-ruby/0-introduction/
