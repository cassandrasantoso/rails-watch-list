# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "json"

puts "Creating movies from the list"

Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
# Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)

puts "Creating movies from le wagon tmdb"

url = "https://tmdb.lewagon.com/movie/top_rated"
serialized_movies = URI.open(url).read
movies = JSON.parse(serialized_movies)["results"]

movies.each do |movie|
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end

puts "Movies #{movies.count} added."

puts "Creating lists with photos"

list = List.create!(name: "Comedy")
unless list.photo.attached?
  photo = URI.parse("https://dnm.nflximg.net/api/v6/2DuQlx0fM4wd1nzqm5BFBi6ILa8/AAAAQaUiPLJpaxXAL-CGwnV-UUKic7arMB-yY4SY7enUbFgSksNG0BClmStlVX4vJO7EIkOODAr7zgP5aO0sPt3iG3XKNVEfbyLY-xQ4bMpzVHHRkSziQ5MnueXkDn4VXT2RfN7C4QEgg-2OvnrRVTfNluW7.jpg?r=936").open
  list.photo.attach(io: photo, filename: "photo.jpg", content_type: "image/jpeg")
end

list = List.create!(name: "Action")
unless list.photo.attached?
  photo = URI.parse("https://deadline.com/wp-content/uploads/2025/05/Rambo-First-Blood.webp?w=681&h=383&crop=1").open
  list.photo.attach(io: photo, filename: "photo.webp", content_type: "image/webp")
end
