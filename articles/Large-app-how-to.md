This document is an attempt to describe the first step of a large project structure with flask and some basic modules:

* SQLAlchemy
* WTForms

Please feel free to fix and add your own tips.

# Installation

## Flask

[Flask Installation](http://flask.pocoo.org/docs/installation/)<br/>
I recommend using virtualenv: it is easy and allows multiple environments on the same machine and doesn't even require you to have super user rights on the machine (as the libs are locally installed).

## Flask-SQLAlchemy

SQLAlchemy provides an easy and advanced way to serialize your object to different types of relational databases. In your virtualenv, install Flask-SQLAlchemy from pip:

    pip install flask-sqlalchemy

[More here about the Flask-SQLAlchemy package](http://packages.python.org/Flask-SQLAlchemy/)

## Flask-WTF

WTForms provides an easy way to handle user's data submission.

    pip install Flask-WTF

[More here about the Flask-WTF package](http://packages.python.org/Flask-WTF/)

# Overview

Ok, so from now, we should have all the libs ready. Here are the folder structures:

    /config.py
    /run.py
    /shell.py 
    /app.db
    /app/__init__.py
    /app/constants.py
    /app/static/

For every module (or sub app... ) we'll have this file structure (here for the `users` module)

    /app/users/__init__.py
    /app/users/views.py
    /app/users/forms.py
    /app/users/constants.py
    /app/users/models.py
    /app/users/decorators.py

For every module that needs templating (jinja) we store those in the templates folder + module directory.

    /app/templates/404.html
    /app/templates/base.html
    /app/templates/users/login.html
    /app/templates/users/register.html
    ...

You should serve your static files with a dedicated http server, but during the development, we'll let flask serve them. Flask will automagically serve static files from the `static/` folder. If you want to use another folder... you can read about that here: http://flask.pocoo.org/docs/api/#application-object 

    /app/static/js/main.js
    /app/static/css/reset.css
    /app/static/img/header.png

We'll create 4 modules, a user module (manage user's registration, login, lost password, profile edit and maybe third-party login/registration) an emails module intended to be used by a queuing server, and a posts and comments modules.

## Config

`/run.py` will be used to launch the web server.

```python
    from app import app
    app.run(debug=True)
```

`/shell.py` will allow you to get a console and enter commands within your flask environment. Maybe not as nice as debugging with pdb, but always useful (when you will initialize your database).

```python
    #!/usr/bin/env python
    import os
    import readline
    from pprint import pprint

    from flask import *
    from app import *

    os.environ['PYTHONINSPECT'] = 'True'
```

`/config.py` will be storing all the module configurations. Here, the database is setup to use SQLite, because it's a very convenient dev env database. Most likely `/config.py` won't be a part of your repository and will be different on your test and production servers.

```python
    import os
    _basedir = os.path.abspath(os.path.dirname(__file__))

    DEBUG = False

    ADMINS = frozenset(['youremail@yourdomain.com'])
    SECRET_KEY = 'This string will be replaced with a proper key in production.'

    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(_basedir, 'app.db')
    DATABASE_CONNECT_OPTIONS = {}

    THREADS_PER_PAGE = 8

    CSRF_ENABLED = True
    CSRF_SESSION_KEY = "somethingimpossibletoguess"

    RECAPTCHA_USE_SSL = False
    RECAPTCHA_PUBLIC_KEY = '6LeYIbsSAAAAACRPIllxA7wvXjIE411PfdB2gt2J'
    RECAPTCHA_PRIVATE_KEY = '6LeYIbsSAAAAAJezaIq3Ft_hSTo0YtyeFG-JgRtu'
    RECAPTCHA_OPTIONS = {'theme': 'white'}
```

* `_basedir` is a trick for you to get the folder where the script runs
* `DEBUG` indicates that it is a dev environment, you'll get the very helpful error page from flask when an error occurs.
* `SECRET_KEY` will be used to sign cookies. Change it and all your users will have to login again.
* `ADMINS` will be used if you need to email information to the site administrators.
* `SQLALCHEMY_DATABASE_URI` and `DATABASE_CONNECT_OPTIONS` are SQLAlchemy connection options (hard to guess)
* `THREAD_PAGE` my understanding was 2/core... might be wrong :)
* `CSRF_ENABLED` and `CSRF_SESSION_KEY` are protecting against form post fraud
* `RECAPTCHA_*` WTForms comes with a `RecaptchaField` ready to use... just need to go to recaptcha website and get your public and private key.

## First module

We'll start with the users modules. In order, we'll define the models, the constants linked to this model, the form and finally the first view and its template.

### First model (and its constants file)

The `/app/users/models.py`:

```python
    from app import db
    from app.users import constants as USER

    class User(db.Model):

        __tablename__ = 'users_user'
        id = db.Column(db.Integer, primary_key=True)
        name = db.Column(db.String(50), unique=True)
        email = db.Column(db.String(120), unique=True)
        password = db.Column(db.String(120))
        role = db.Column(db.SmallInteger, default=USER.USER)
        status = db.Column(db.SmallInteger, default=USER.NEW)

        def __init__(self, name=None, email=None, password=None):
          self.name = name
          self.email = email
          self.password = password

        def getStatus(self):
          return USER.STATUS[self.status]

        def getRole(self):
          return USER.ROLE[self.role]

        def __repr__(self):
            return '<User %r>' % (self.name)
```

and its constants in the `/app/users/constants.py` file:

```python
    # User role
    ADMIN = 0
    STAFF = 1
    USER = 2
    ROLE = {
      ADMIN: 'admin',
      STAFF: 'staff',
      USER: 'user',
    }

    # user status
    INACTIVE = 0
    NEW = 1
    ACTIVE = 2
    STATUS = {
      INACTIVE: 'inactive',
      NEW: 'new',
      ACTIVE: 'active',
    }
```

First about the constants file, I like to have my constants in their own file and inside my module for 2 main reasons. Your constants will probably be used in your models, forms and views. The second reason is that it's a better organization for you to find them. Also, importing your constants as the module in uppercase indicates the constant type and the module name (like `USER` for `users.constants`) will help you avoid name conflicts. 

### First form

Now that we've done our object model, time to build the form that goes with it. We'll start with a registration and login form. The registration form will request the user's name, email and password. We'll use validators to ensure the user submitted correct values. Finally, a Recaptcha field (provided by flask) will avoid machine registration. Just in case you plan on having a Terms of Service, I added a `BooleanField` called accept_tos. Since this field is required, the user will have to check the checkbox generated by this field on the box. The login form will have only email and password with the same validators. Here's the `/app/users/forms.py` file:

```python
    from flask.ext.wtf import Form, RecaptchaField
    from wtforms import TextField, PasswordField, BooleanField
    from wtforms.validators import Required, EqualTo, Email

    class LoginForm(Form):
      email = TextField('Email address', [Required(), Email()])
      password = PasswordField('Password', [Required()])

    class RegisterForm(Form):
      name = TextField('NickName', [Required()])
      email = TextField('Email address', [Required(), Email()])
      password = PasswordField('Password', [Required()])
      confirm = PasswordField('Repeat Password', [
          Required(),
          EqualTo('password', message='Passwords must match')
          ])
      accept_tos = BooleanField('I accept the TOS', [Required()])
      recaptcha = RecaptchaField()
```

The first parameter for the field is the label we'll want to display for it. For example the name field will be labelled as NickName on the form. For the password fields, another useful validator got used here, `EqualTo`, it compares the data contained in the current field with the data of the other specified field.

For more details of what can be done with WTForms check [here](http://wtforms.simplecodes.com/docs/dev/).

### First view 

The view is where we'll declare our Blueprint. Using `url_prefix` will prefix every url you set using route. A nice feature from Flask-WTF is the `form.validate_on_submit` method: it checks that the current request is a POST and that the form validates. Once the user is logged in we want to redirect the user to his profile (`/users/me/`). To prevent unauthenticated users to access this page, we'll create a decorator to protect it (`/app/users/decorators.py`):

```python
    from functools import wraps

    from flask import g, flash, redirect, url_for, request

    def requires_login(f):
      @wraps(f)
      def decorated_function(*args, **kwargs):
        if g.user is None:
          flash(u'You need to be signed in for this page.')
          return redirect(url_for('users.login', next=request.path))
        return f(*args, **kwargs)
      return decorated_function
```

This decorator is checking that g.user has a value assigned to it, otherwise it means that the user isn't authenticated, we then add a message to be displayed to the user on the next page and redirect him to the login view. You probably wonder how `g.user` gets defined, it's in the user's `views.py`, through the `before_request`. You'll realize later that if you pull a lot of information from your user's profile (historical data, friends, messages, activities...) this might become a bottle neck and caching user through their id might be a good solution (as long as you centralize your object modifications and clear this cache on every update). Following are the views definition in `/app/users/views.py`:

```python
    from flask import Blueprint, request, render_template, flash, g, session, redirect, url_for
    from werkzeug import check_password_hash, generate_password_hash

    from app import db
    from app.users.forms import RegisterForm, LoginForm
    from app.users.models import User
    from app.users.decorators import requires_login

    mod = Blueprint('users', __name__, url_prefix='/users')

    @mod.route('/me/')
    @requires_login
    def home():
      return render_template("users/profile.html", user=g.user)

    @mod.before_request
    def before_request():
      """
      pull user's profile from the database before every request are treated
      """
      g.user = None
      if 'user_id' in session:
        g.user = User.query.get(session['user_id'])

    @mod.route('/login/', methods=['GET', 'POST'])
    def login():
      """
      Login form
      """
      form = LoginForm(request.form)
      # make sure data are valid, but doesn't validate password is right
      if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        # we use werzeug to validate user's password
        if user and check_password_hash(user.password, form.password.data):
          # the session can't be modified as it's signed, 
          # it's a safe place to store the user id
          session['user_id'] = user.id
          flash('Welcome %s' % user.name)
          return redirect(url_for('users.home'))
        flash('Wrong email or password', 'error-message')
      return render_template("users/login.html", form=form)

    @mod.route('/register/', methods=['GET', 'POST'])
    def register():
      """
      Registration Form
      """
      form = RegisterForm(request.form)
      if form.validate_on_submit():
        # create an user instance not yet stored in the database
        user = User(name=form.name.data, email=form.email.data, \
          password=generate_password_hash(form.password.data))
        # Insert the record in our database and commit it
        db.session.add(user)
        db.session.commit()

        # Log the user in, as he now has an id
        session['user_id'] = user.id

        # flash will display a message to the user
        flash('Thanks for registering')
        # redirect user to the 'home' method of the user module.
        return redirect(url_for('users.home'))
      return render_template("users/register.html", form=form)
```

## First template

Jinja is integrated within Flask. One of the great features of Jinja is the inheritance and the logic available (conditional structure, loop, context modification...). We'll create a `/app/templates/base.html` template which we'll inherit from, on each of our templates. You can even have more than 1 inheritance (like having your template inheriting from `twocolumn.html` template which itself inherits from `main.html`). The base template is also a good place to display flash messages (`get_flashed_messages`), so every template will now display messages when needed.

```jinja
    <html>
      <head>
        <title>{% block title %}My Site{% endblock %}</title>
        {% block css %}
        <link rel="stylesheet" href="/static/css/reset-min.css" />
        <link rel="stylesheet" href="/static/css/main.css" />
        {% endblock %}
        {% block script %}
        <script src="/static/js/main.js" type="text/javascript"></script>
        {% endblock %}
      </head>
      <body>
        <div id="header">{% block header %}{% endblock %}</div>
        <div id="messages-wrap">
          <div id="messages">
            {% for category, msg in get_flashed_messages(with_categories=true) %}
              <p class="message flash-{{ category }}">{{ msg }}</p>
            {% endfor %}
          </div>
        </div>
        <div id="content">{% block content %}{% endblock %}</div>
        <div id="footer">{% block footer %}{% endblock %}</div>
      </body>
    </html>
```

Now we won't have to redefine our html structure anymore, and any modification done on `base.html` will be visible on all your child templates. Here is the `/app/templates/users/register.html` template (It's a good habit to use the view name for the template file name).

```jinja
    {% extends "base.html" %}
    {% block content %}
      {% from "forms/macros.html" import render_field %}
      <form method="POST" action="." class="form">
        {{ form.csrf_token }}
        {{ render_field(form.name, class="input text") }}
        {{ render_field(form.email, class="input text") }}
        {{ render_field(form.password, class="input text") }}
        {{ render_field(form.confirm, class="input text") }}
        {{ render_field(form.accept_tos, class="input checkbox") }}
        <label>ReCaptcha</label>
        {{ form.recaptcha }}
        <input type="submit" value="Register" class="button green">
      </form>
      <a href="{{ url_for('users.login') }}">Login</a>
    {% endblock %}
```

and here is the `/app/templates/users/login.html` template:

```jinja
    {% extends "base.html" %}
    {% block content %}
      {% from "forms/macros.html" import render_field %}
      <form method="POST" action="." class="form">
        {{ form.csrf_token }}
        {{ render_field(form.email, class="input text") }}
        {{ render_field(form.password, class="input text") }}
        <input type="submit" value="Login" class="button green">
      </form>
      <a href="{{ url_for('users.register') }}">Register</a>
    {% endblock %}
```

Those templates will use a macro to automate the construction of html fields. This macro will be stored in `/app/templates/forms/macros.html` (since this macro will be called in different modules, we'll store it in a separated file).

```jinja
    {% macro render_field(field) %}
        <div class="form_field">
        {{ field.label(class="label") }}
        {% if field.errors %}
            {% set css_class = 'has_error ' + kwargs.pop('class', '') %}
            {{ field(class=css_class, **kwargs) }}
            <ul class="errors">{% for error in field.errors %}<li>{{ error|e }}</li>{% endfor %}</ul>
        {% else %}
            {{ field(**kwargs) }}
        {% endif %}
        </div>
    {% endmacro %}
```

Finally, a simple `/app/templates/users/profile.html`:

```jinja
   {% extends "base.html" %}
   {% block content %}
     Hi {{ user.name }}!
   {% endblock %}
```

## Setting up the app

Here is the `/app/__init__.py` :

```python
    import os
    import sys
    
    from flask import Flask, render_template
    from flask.ext.sqlalchemy import SQLAlchemy

    app = Flask(__name__)
    app.config.from_object('config')

    db = SQLAlchemy(app)

    ########################
    # Configure Secret Key #
    ########################
    def install_secret_key(app, filename='secret_key'):
        """Configure the SECRET_KEY from a file
        in the instance directory.

        If the file does not exist, print instructions
        to create it from a shell with a random key,
        then exit.
        """
        filename = os.path.join(app.instance_path, filename)
        
        try:
            app.config['SECRET_KEY'] = open(filename, 'rb').read()
        except IOError:
            print('Error: No secret key. Create it with:')
            full_path = os.path.dirname(filename)
            if not os.path.isdir(full_path):
                print('mkdir -p {filename}'.format(filename=full_path))
            print('head -c 24 /dev/urandom > {filename}'.format(filename=full_path))
            sys.exit(1)

    if not app.config['DEBUG']:
        install_secret_key(app)

    @app.errorhandler(404)
    def not_found(error):
        return render_template('404.html'), 404

    from app.users.views import mod as usersModule
    app.register_blueprint(usersModule)

    # Later on you'll import the other blueprints the same way:
    #from app.comments.views import mod as commentsModule
    #from app.posts.views import mod as postsModule
    #app.register_blueprint(commentsModule)
    #app.register_blueprint(postsModule)
```

Our SQLAlchemy db instance and models (User) are separated in two files, you need import both of them into namespace, which is done by `from app.users.views import mod as usersModule` implicitly. Otherwise the `db.create_all()` will do nothing.

Let's activate your virtualenv and initialize your database:

    user@Machine:~/Projects/dev$ . env/bin/activate
    (env)user@Machine:~/Projects/dev$ python shell.py 
    >>> from app import db
    >>> db.create_all()
    >>> exit()

now you can go in your root and run `python run.py` ... this should give you something like this:

    (env)user@Machine:~/Projects/dev$ python run.py 
     * Running on http://127.0.0.1:5000/
     * Restarting with reloader

Open your web-browser at [http://127.0.0.1:5000/users/me/], you should be redirected to the login page and see a link to the register page.

# Other good practices

# Testing

## Caching

## Javascript namespaces

# Setting up your web server

## NGinx

## Apache