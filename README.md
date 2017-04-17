# Wireframes

# Versions

* Ruby 2.3.1+
* Rails 5.0

# Models
## User

**Attributes**
* name:string
* email:string
* password_digest:string
* photo: string
* points: integer (default = 0)
* users_notes(upvotes - downvotes) + users_comments(upvotes - downvotes) recalculate every time someone up/downvotes your     comment/note
* privilege: integer (default = 0)

  0. → Basic 
      * flag comments
      * down/up vote
  1. → Moderator
      * edit notes
      * delete comments
  2. → Admin
      * delete notes
      * create courses
      
* a user’s privilege is based on their points

     1. 0-50 = basic
     2. 50+ = moderator
* favorites:  [note_ids] → [integer…]
* default_course_id: integer
* location_id: integer 

**Associations**
* has_many :notes
* has_many :comments


## Location
**Attributes**
* name: string
**Associations**
(none)

## Note
**Attributes**
* title:string
* content: text
* up_votes: [ user_ids] → [integer…]
* down_votes: [ user_ids] → [integer…]
* course_id: integer

       by default this will be the user’s default_course_id 
       the user can change this when creating/editing the note
* whitelist : [user_ids] → [integer…]

        by default, when a note is created the whitelist contains the user’s id
        This note is private/draft and can only be viewed by the user that created the note
        if a user makes the note “public” the whitelist is cleared (empty). All users can view the note
        if a user wants to share a note with only select users, those user ids will be added to/deleted from the whitelist
* image_urls [string…] - 5 images per note(?)

**Associations**
* belongs_to :user → user:references
* belongs_to :course → course:references
* has_many :comments
* has_and_belongs_to_many :tags → 
* rails g model notes_tags note:references tag:references --force-plural




## Comment
**Attributes**
* content: text
* up_votes: [ user_ids] → [integer…]
 *down_votes: [ user_ids] → [integer…]

**Associations**
* belongs_to :user → user:references
* belongs_to :note → note:references


## Tag
**Attributes**
* tag_name: string

**Associations**
* has_and_belongs_to_many :notes


## Course
**Attributes**
* name: string
**Associations**
* has_many :notes


# Routes

METHOD|URL|Controller#Action|PURPOSE|DATA
------|---|-----------------|-------|-----
GET |‘/’||Landing Page| |
GET |‘/notes’|notes#index|Show All Notes|Notes DB|
GET |‘/:category’| |Show notes from category|Notes DB|
GET |‘/signup’| |Sign up page| |
POST|‘/signup’| |Complete sign up|User DB |
GET |‘/login’| |Login| |
POST|‘/login’| |Attempt Login|User DB|
GET |‘/:tag’||Show notes with tag|Notes DB|
GET |‘/profile’| |View logged-in user profile|User DB/Session|
GET |‘/profile/edit’| |Edit profile|User DB|
PUT |‘/profile/edit’| |Submit edits|User DB|
GET |‘/notes/new’| |New Note Page| |
POST|‘/notes/new’| |Post new note|Notes DB|
GET |‘/notes/:id/edit’| |Edit note page|Notes DB|
PUT |‘/notes/:id/edit’| |Submit edit|Notes DB|
GET |‘/notes/:id/’| |View Single Note|Notes/Comments DB|
GET |‘/search’| |Search through notes|Notes DB|
GET |‘/profile/:id’||View specific user profile|Users DB|
GET |‘/favorites’| |View my favorites|User/Notes DB|
DELETE|‘/notes/:id’| |Delete Specific Notes|Notes DB|
DELETE|‘/profile’||Delete my profile| |
DELETE|‘/comments/:id’||Delete comments|Comment DB|
EDIT |‘/comments/:id’| |Edit comments|Comment DB|



