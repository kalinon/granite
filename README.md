# amethyst-model

[Amethyst](https://github.com/Codcore/amethyst) is a web framework written in the [Crystal](https://github.com/manastech/crystal) language. 

This project is to provide a mysql ORM Base::Model that provides simple
database usage.

## Installation

Add this library to your Amethyst dependencies in your Projectfile.

```crystal
deps do
  # Amethyst Framework
  github "Codcore/amethyst"
  github "spalger/crystal-mime"

  # Amethyst Model
  github "drujensen/amethyst-model"
  github "waterlink/crystal-mysql"
end
```

Next you will need to create a `config/database.yml`

```yaml
development: 
  database: blog_development
  host: 127.0.0.1
  port: 3306
  username: root
  password: 

test: 
  database: blog_test
  host: 127.0.0.1
  port: 3306
  username: root
  password: 

```

## Usage

Here is classic 'Post' using Amethyst Model

```crystal
require "amethyst-model"
include Amethyst::Model

class Post < Base::Model
  fields({ name: "VARCHAR(255)", body: "TEXT" })

  # properties id, name, body, created_at, updated_at are generated for you

end

```
### Fields

To define the fields for this model, you need to provide a hash with the name of the field as a `Symbol` and the MySQL type as a `String`.  This can include any other options that MySQL provides to you.  

3 Fields are automatically created for you:  id, created_at, updated_at.
These will also be set for you when you use the `save` method.

### DDL Built in

```crystal
Post.drop #drop the table

Post.create #create the table

Post.clear #truncate the table
```

### DML

#### Find All

```crystal
posts = Post.all
if posts
  posts.each do |post|
    puts post.name
  end
end
```

#### Find One

```crystal
post = Post.find 1
if post
  puts post.name
end
```

#### Insert

```crystal
post = Post.new
post.name = "Amethyst Rocks!"
post.body = "Check this out."
post.save
```

#### Update

```crystal
post = Post.find 1
post.name = "Amethyst Really Rocks!"
post.save
```

#### Delete

```crystal
post = Post.find 1
post.destroy
puts "deleted" unless post
```

### Where 

The where clause will give you full control over your query. Instead of building another DSL to build the query, we decided to use good ole SQL.

When using the all method, the selected fields will always match the fields specified in the model.  If you need different fields, consider creating a new model.

Always pass in parameters to avoid SQL Injection.  Use a symbol in your query `:field` for parameter replacements.

The table is namespaced with `_t` so you can perform joins without conflicting
field names.

```crystal
posts = Post.all("WHERE name LIKE :name", {"name" => "Joe%"})
if posts
  posts.each do |post|
    puts post.name
  end
end

# ORDER BY Example
posts = Post.all("ORDER BY created_at DESC")

# JOIN Example
posts = Post.all(", comments c WHERE c.post_id = _t.id AND c.name = :name ORDER BY created_at DESC", {"name" => "Joe"})

```

### More Control

There are two additional methods `query` and `mapping` that will provide you the ability to have even more control over your model.  This will allow you to create a model that can perform complex queries and map the results to properties.

#### The Mapping Method
The Mapping method provides the Object Relational Mapping of the results from the query to an instance of a model.  It is called for each row in the table.  

Be aware that the `fields` macro creates a `mapping` for you, so its recommended
that you don't overwrite this if your using `fields`.  

#### The Query Method
This method provides you full MySQL query capabilities.  The selected fields
need to be mapped to properties in your `mapping` method so they work in
concert with each other.

```crystal
require "amethyst-model"
include Amethyst::Model

class PostCountByMonth < Base::Model
  property :month, :count

  # override mapping defined in Base::Model
  def mapping(results : Array)
    result = PostCountByMonth.new
    result.month = results[0]
    result.count = results[1]
    return result
  end

  # a method that will execute the query and return the results.
  def doit
    query("SELECT MONTH(created_at), COUNT(*) FROM posts 
    GROUP BY created_at", {})
  end

end

```



## RoadMap
- Connection Pool
- has_many, belongs_to support

## Contributing

1. Fork it ( https://github.com/drujensen/amethyst-model/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [drujensen](https://github.com/drujensen) drujensen - creator, maintainer
