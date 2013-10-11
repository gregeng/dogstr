require_relative './environment'

# 100.times do
#   Dog.new.tap do |d|
#     d.name = Faker::Name.name 
#     d.color = Faker::Lorem.word
#     d.bio = Faker::Lorem.paragraph
#     d.save
#   end
# end

index = ERB.new(File.open('lib/templates/index.erb').read)
dogs = Dog.all

File.open('_site/index.html', 'w+') do |f|
  f << index.result(binding)
end

show = ERB.new(File.open('lib/templates/show.erb').read)
# For each dog, first, cast the dog into instance var

dogs.each do |dog|
  File.open("_site/dogs/#{dog.url}.html", 'w+') do |f|
    f << show.result(binding)
  end
end

