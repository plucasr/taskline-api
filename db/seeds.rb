user = User.create!(email: "demo@taskline.dev", password: "password", password_confirmation: "password")

board = Board.create!(name: "Product Roadmap")
user.board_memberships.create!(board: board, role: :owner)

backlog = board.columns.create!(name: "Backlog", position: 0)
doing = board.columns.create!(name: "In Progress", position: 1)
done = board.columns.create!(name: "Done", position: 2)

backlog.cards.create!(title: "Draft API spec", position: 0)
backlog.cards.create!(title: "Design board UI", position: 1)
doing.cards.create!(title: "JWT auth", position: 0)
done.cards.create!(title: "Project scaffold", position: 0)
