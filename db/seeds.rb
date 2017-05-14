# app assumes that id = 1 is Basic and id = 2 is Admin
Privilege.create!([
  {name: "Basic"},
  {name: "Admin"}
])

Course.create!([
  {name: 'Web Development Immersive', code: 'WDI', description: 'Learn and apply the skills you need to start a career in code.'},
  {name: 'User Experience Design Immersive', code: 'UXDI', description: 'Crafted by top practitioners in the field, with a specific focus on helping you transition into a UX design career.'},
  {name: 'Data Science Immersive', code: 'DSI', description: 'Learn the tools and techniques you need to make better decisions through data, and land a job in one of the most sought after fields in tech.'},
  {name: 'General', code: 'GEN', description: 'Mostly everything.', is_official_course: false},
  {name: 'Outcomes', code: 'OC', description: 'Resources for outcomes programming and job search.', is_official_course: false},
])

Location.create!([
  {name: "Seattle"},
  {name: "New York"},
  {name: "Denver"},
  {name: "Atlanta"},
  {name: "Austin"},
  {name: "Boston"},
  {name: "Chicago"},
  {name: "Los Angeles"},
  {name: "San Francisco"}
])

# Create initial admin user. Note : password should be changed immediately after
User.create!([
 {name: 'Michael Scott', email: 'michael@scott.com', password: 'password', privilege: 2}
])
