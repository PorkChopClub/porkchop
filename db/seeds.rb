Table.create!(name: Table::DEFAULT_TABLE_NAME)

Player.create!(name: "Jared Norman",
               email: "admin@stembolt.com",
               password: "password",
               confirmed_at: 1.day.ago,
               avatar_url: "/avatars/jared.png")

Player.create!(name: "Gray Gilmore",
               email: "gray@example.com",
               password: "password",
               avatar_url: "http://i.imgur.com/s7d1vVo.png")

Player.create!(name: "Adam Mueller",
               email: "adam@example.com",
               password: "password",
               avatar_url: "http://i.imgur.com/2jhmPJv.png")

Player.create!(name: "Chris Todorov",
               email: "chris@example.com",
               password: "password",
               avatar_url: "https://dl.dropboxusercontent.com/u/499982/chris.png")

Player.create!(name: "John Hawthorn",
               email: "john@example.com",
               password: "password",
               avatar_url: "http://i.hawth.ca/u/john2000.png")
