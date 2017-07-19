# Photogram Golden Seven

## RCAV + CRUD

The goal of this project is to understand how to allow users to generate data for our database tables through their browsers. To do this, you will write one complete database-backed web CRUD **resource**. When we say "resource", we mean:

 - a database table
 - a Ruby class to represent it (called a "model")
 - the complete set of RCAVs that are required for users to create, read, update, and delete rows in the table through forms and links in their browsers.

Web applications are not much more than a collection of related resources that users can CRUD, so understanding how each of these operations works on one table is essential. **CRUD resources are the fundamental building blocks that the web is built out of.** (The _R_ in URL stands for "Resource"; **U**niform **R**esource **L**ocator.)

To start with, we'll keep it simple and manage just one resource: photos. Our goal is to build an app that lets users submit URLs of photos and add captions for them, like this:

### [This is the first, _intermediate_, target you should aim to build.](https://photogram-g7-intermediate.herokuapp.com/)

Eventually, we'll add the ability to sign up, upload photos, and follow other users, and we'll wind up building Instagram. But for now, anonymous visitors will simply copy-paste the URLs of images that are already on the Internet.

**We just need to put together everything we've learned about RCAV with everything we've learned about CRUDing models with Ruby.**

You might as well pull up the [RCAV Flowchart](https://guides.firstdraft.com/rcav-flowchart.html) and the [CRUD with Ruby](https://guides.firstdraft.com/crud-with-ruby.html) guides in new tabs right now; you'll need them. Remember, programmers don't memorize; it's just a question of reasoning about the task at hand and then looking up the syntax to achieve it.

---

At the most basic level, our job when building web apps is to build support for **addresses** that users can visit that, when visited, **trigger controller actions** which perform the interaction that the user wants.

Then we need to give the users a convenient way to visit that URL (there's only two ways: either a link or a form submit button which point to that URL).

## Inter- _face_ versus Inter- _nals_

For each of the following apps that we've built in the past, click around the targets

 - [rps_rcav](https://rps-rcav-target.herokuapp.com/)
 - [omnicalc_params](https://omnicalc-params.herokuapp.com/)

and try to identify:

 - What are the URLs that users can visit? On each page,
    - What is the key info that users should be able to see?
    - What links should they be able to click?
        - Do we perform any CRUD on a table(s)?
        - Where should they end up?
    - What forms should they be able to fill out?
        - Do we perform any CRUD on a table(s)?
        - Where should they end up?

Of course, since those two apps didn't have any tables, there was no CRUD. But it's still instructive to see how the list of URLs that users can visit / actions that they can take entirely defines the application.

Now, try and do the same for the app we are about to build: [our intermediate Photogram target](https://photogram-g7-intermediate.herokuapp.com/). Click around it and try to identify:

- What are the URLs that users can visit? On each page,
   - What is the key info that users should be able to see?
   - What links should they be able to click?
       - Do we perform any CRUD on a table(s)?
       - Where should they end up?
   - What forms should they be able to fill out?
       - Do we perform any CRUD on a table(s)?
       - Where should they end up?

Write down all of the URLs that you think we are going to have to build support for in order to write this app.

Then, we can write routes for each one of them.

Then, we can connect the RCAV dots for each and get something to show up.

Then, we can write static HTML mockups for each.

Then, we can embed some instance variables in the templates where we need them to be dynamic.

Then, we can write controller logic to put the right info into the instance variables (and, now, we can also perform CRUD to save data permanently, if needed).

Then, we'll be done!

(Hint: As you are clicking around the target and trying to identify all of the URLs that we'll have to build support for, remember from [omnicalc_params](https://omnicalc-params.herokuapp.com/) that every form requires two RCAVs: one to display the form, and one to process the inputs after the user clicks submit.)

Once you've written down your guess at all of the routes, compare them with your neighbor.

---

---

---

**For a standard CRUD resource**, we usually support seven actions. **The Golden Seven** actions are:

### Create

 - `"/photos/new"`: displays a blank form to the user
 - `"/create_photo"`: receives info from the new form and inserts a row into the table

### Read

 - `"/photos"`: displays a list of multiple rows (and links to get to details pages, edit forms, and to delete them)
 - `"/photos/4"`: displays the details of one row (in this example, the one with ID number 4); (and links to an edit form, to delete it, and to go back to the index)

### Update

 - `"/photos/4/edit"`: displays a pre-populated form for the user to edit an existing photo (in this example, the one with ID number 4)
 - `"/update_photo/4"`: receives info from a form and updates a row in the table (in this example, the one with ID number 4)

### Delete

 - `"/delete_photo/4"`: removes a row from the table (in this example, the one with ID number 4)

Now that we've identified the entire interface of the application, we can get started building it!

## Setup

 1. Ensure that you've forked this repo to your own GitHub account.
 1. Set up [a Cloud9 workspace as usual](https://guides.firstdraft.com/getting-started-with-cloud-9.html) based on this repo.
 1. `bin/setup`
 1. Run Project
 1. Navigate to the live app in Chrome.

## Generate the database table

> You can skip this section, because in this project I've done it for you. But here's what you'd normally do to create a table to store data in.

(Your [CRUD with Ruby guide](https://guides.firstdraft.com/crud-with-ruby.html) will be handy for all CRUD-related portions of this project.)

First, we need an underlying database table to store photos. In this project, I've already done this step for you, but in future projects you would have to do something like the following:

```bash
rails generate model photo caption:text source:string
```

This is a command line command, not a Ruby expression, so don't attempt to execute it within `rails console`. Run it at a regular Terminal prompt.

This command will generate two files:

 - A migration file that contains a Ruby script that, when executed, will create a table called "photos" with two columns in it; "caption" and "source".
 - A Ruby class called `Photo` that will represent this table so that we can interact with it easily.

You would then the migration with:

```bash
rails db:migrate
```

You would then have a database table!

### Add some data manually

Now that we have a table, we can add some data to it. The easiest way is using an administrative dashboard gem that I've added to the project called ActiveAdmin. Navigate to `/admin` and sign in with `admin@example.com / password`.

If you tell ActiveAdmin what your models are, it gives you a powerful and customizable admin dashboard out-of-the-box! Pretty neat. For now, click on the "Photos" link in the navbar and add a few rows. For "source", you can grab the URL of any image on the internet; try right-clicking on the Google logo in Chrome, for example, and "Copy Image Address".

Okay, as nice as having this admin dashboard is for CRUDing data into our table, what we really need to do is learn how to CRUD with Ruby so that we can write some RCAVs to let _our users_ do interesting things, not us.

Let's experiment with the Ruby to CRUD rows in the photos table. Jump into `rails console` and do some CRUD with Ruby:

```ruby
Photo.count
Photo.first

p = Photo.new
p.source = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/SQM_GE_289A_Boxcab_Carmelita_-_Reverso.jpg/640px-SQM_GE_289A_Boxcab_Carmelita_-_Reverso.jpg"
p.caption = "Train"
p.save

Photo.count
Photo.last

Photo.find(1)
```

### Pre-populate the table with more data quickly

To save us some time, we've prepared a Ruby script that will repeat the above process 16 times. Run the script with the following command:

```bash
rails dev:prime
```

You can re-run this command whenever you want to add 16 more rows to the table (useful if you, for example, delete all of the rows while testing your delete link).

## Implement the Golden Seven

### Stub out all seven RCAVs

Let's quickly complete all seven RCAVs. Here are the routes we'll need for the URLs we identified above, with some sensible sounding controller and action names and somewhat silly flexible segment names:

```ruby
# CREATE
get("/photos/new", { :controller => "pictures", :action => "new_form" })
get("/create_photo", { :controller => "pictures", :action => "create_row" })

# READ
get("/photos", { :controller => "pictures", :action => "index" })
get("/photos/:the_id", { :controller => "pictures", :action => "show" })

# UPDATE
get("/photos/:an_id/edit", { :controller => "pictures", :action => "edit_form" })
get("/update_photo/:some_id", { :controller => "pictures", :action => "update_row" })

# DELETE
get("/delete_photo/:toast_id", { :controller => "pictures", :action => "destroy_row" })
```

(Your [RCAV Flowchart](https://guides.firstdraft.com/rcav-flowchart.html) guide will be handy for all RCAV-related portions of this project.)

For each one, complete the RCAV. In the view template, simply add an `<h1>Hi</h1>` to prove that you connected the RCAV dots without any bugs.

### READ (index, show)

Our first goal will be to allow users to READ photos -- individual details, and a list of all of them.

 - We'll have to add two routes:
  - `get("/photos/:id", { :controller => "pictures", :action => "show" })`
  - `get("/photos",     { :controller => "pictures", :action => "index" })`
  - (as well as a route for the bare domain, which also goes to the `index` action)

We'll eventually want links on the index page that lead to the details page of each photo that look like:

 - [/photos/1](/photos/1)
 - [/photos/2](/photos/2)
 - [/photos/3](/photos/3)
 - [/photos/4](/photos/4)

Hints: Remember your [CRUD with Ruby guide](https://guides.firstdraft.com/crud-with-ruby.html), and what you know about the `params` hash.

### CREATE (new_form, create_row)

We're now done with the "R" in CRUD. Our users can **Read** individual rows and collections of rows from our photos table. But they still have to depend on us to create the data in the first place, through the Rails console or something.

Let's now attack the "C" in CRUD: **Create**. We want to allow users to generate content for our applications; that is almost always where the greatest value lies.

#### new_form

The first step is: let's give the user a form to type some stuff in to. Add the following route:

    get("/photos/new", { :controller => "pictures", :action => "new_form" })

**Note: If you add this below the `show` route, Rails will get confused. (Why?) Add this route above the show route instead.**

This action has a very simple job: draw a blank form in the user's browser for them to type some stuff into.

It's been a while since we've done any forms, but let's shake off the rust and craft a form for a photo with two inputs: one for the image's URL and one for a caption. Complete the RCAV and add the following HTML in the view:

```html
<form action="/create_photo">
  <div>
    <label for="source_input">
      Image URL
    </label>

    <input id="source_input" type="text" name="the_source">
  </div>

  <div>
    <label for="caption_input">
      Caption
    </label>

    <input id="caption_input" type="text" name="the_caption">
  </div>

  <button>
    Create Photo
  </button>
</form>
```

It turns out that forms, when submitted, take the values that users type in to the inputs and add them to the request. However, they do it by tacking them on to the end of the URL after a `?`, in what is called a **query string**.

"Query string" is HTTP's name for a list of key/value pairs. The **keys** are the `name`s of the `<input>` tags, and the **values** are what the user typed.

In Ruby, we call a list of key/value pairs a Hash. Same thing, different notation. So

```
?sport=football&color=purple
```

in a URL would translate into something like

```
{ :sport => "football", :color => "purple" }
```

in Ruby.

Why do we care? Well, it turns out that Rails does exactly that translation when it sees a query string show up on the end of one of our URLs.

Rails ignores the query string as far as routing is concerned, and still sends the request to same action... but it puts the extra information from the form into the `params` hash for us!

Alright, we're getting close... there's only one problem left. When a user clicks submit on the form, we probably don't want to go right back to the `new_form` action again. That action's job was to draw the blank form on the screen, and we're right back where we started.

We need a way to pick a different URL to send the data to when the user clicks the submit button. If we could do that, then we could set up a route for that URL, and then in the action for that route, we could pluck the information the user typed from the `params` hash and use it to create a new row in our table.

Fortunately, we can very easily pick which URL receives the data from a form: it is determined by adding an `action` attribute to the `<form>` tag, like so:

```html
<form action="/create_photo">
```

Think of the action attribute as being like the `href` attribute of the `<a>` tag. It determines where the user is sent after they click. The only difference between a form and a link is that when the user clicks a form, some extra data comes along for the ride, but either way, the user is sent to a new URL.

Of course, if you click it right now, you'll just see "Hi", since that's all that the action does right now. Let's make it smarter, and process the inputs from the form.

#### create_row

```ruby
get("/create_photo", { :controller => "pictures", :action => "create_row" })
```

**Your next job** is to write some Ruby in the `create` action to:

 - create a new row for the photos table
 - fill in its column values by pulling the information the user typed into the form out of the `params` hash
 - save it

Once this action has done its job of adding a row to the table, we have to make a choice: do we display a confirmation message in the view template, or do we simply send the user back to the index page?

If the former, simply add whatever HTML to the view template you think is appropriate. It's usually helpful to at least include a link back to the index page.

If you instead just want to send the user back to the index page immediately, try the following in the action instead of `render`:

```ruby
redirect_to("/photos")
```

or just

```ruby
redirect_to("/photos")
```

### [Your _final_ target demonstrates how these redirects should work.](https://photogram-g7-final.herokuapp.com/)

### DELETE (destroy)

Under each photo on the index page, add a link labeled "Delete". The markup for these links should look like:

```html
<a href="/delete_photo/<%= photo.id %>">Delete</a>
```

Does it make sense how that link is being put together?

When I click that link, the photo should be removed and I should be sent back to the index page.

### UPDATE (edit_form, update_row)

#### edit_form

Under each photo on the index page, there is a link labeled "Edit". The markup for these links should look like:

```html
<a href="/photos/<%= photo.id %>/edit">Edit</a>
```

The job of this action should be to display a form to edit an existing photo, somewhat like the `new_form` action.

It's a little more complicated than `new_form`, though, because instead of showing a blank form, you should show a form that's pre-populated with the current values for a particular photo (determined by what's after the slash).

Hint: You can pre-fill an `<input>` with the `value=""` attribute; e.g.,

```html
<input type="text" name="the_caption" value="<%= @photo.caption %>">
```

The `action` attributes of your edit forms should look like this:

```html
<form action="/update_photo/4">
```

so that when the user clicks submit, we can finally do the work of updating our database. But the `4` should be dynamic, not hardcoded, so embed some Ruby instead:

```html
<form action="/update_photo/<%= @photo.id %>">
```

#### update_row

Finally, the last route will be triggered:

```ruby
get("/update_photo/:some_id", { :controller => "pictures", :action => "update_row" })
```

The job of this action is to receive data from an edit form, retrieve the corresponding row from the table, and update it with the revised information. Give it a shot.

Afterwards, redirect the user to the details page of the photo that was just edited.

## Rinse and repeat

This is optional, but when I was learning this material, I found sheer repetition to be really helpful in connecting the dots in my brain.

A suggestion: jump back in your git history and branch off of an early commit, and try doing it again; referring to these notes less and less.

Rinse and repeat.

## Conclusion

If we can connect all these dots, we will have completed one entire database-backed CRUD web resource. Every web application is essentially just a collection of multiple of these resources; they are the building blocks of everything we do, and we'll just cruise from here.

Struggle with it; **come up with questions**.
