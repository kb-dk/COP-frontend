# COP Frontend

Frontend for the **COP**, built with Ruby on Rails and Blacklight plus a Solr backend.

The application provides the web interface for searching and browsing COP editions. Search and record data are retrieved from a Solr backend.

## Architecture

The application consists primarily of:

* **Ruby on Rails 5.1.7** — web application and frontend
* **Blacklight 6.20.0** — search interface and Solr integration
* **Solr** — backend search/index containing COP edition data
* **Puma 4.3.12** — development web server
* **SQLite** — local Rails development database

## Requirements

The repository is an older Rails application and requires specific versions of Ruby and Bundler.

### Required versions

| Dependency | Version |
| ---------- | ------- |
| Ruby       | 2.6.5   |
| Bundler    | 1.17.2  |
| Rails      | 5.1.7   |
| Blacklight | 6.20.0  |
| Puma       | 4.3.12  |

The exact Ruby and Bundler versions are also reflected in `Gemfile.lock`.

You will need:

* Git
* Ruby 2.6.5
* Bundler 1.17.2
* Node/npm are **not required** to run the Rails application

The easiest way to manage Ruby versions is [`rbenv`](https://github.com/rbenv/rbenv).

---

# Getting started

## 1. Clone the repository

```bash
git clone https://github.com/kb-dk/COP-frontend.git
cd COP-frontend
```

## 2. Install rbenv

On Ubuntu:

```bash
sudo apt update
sudo apt install rbenv ruby-build
```

If the Ubuntu `ruby-build` package is too old to provide Ruby 2.6.5, install/update `ruby-build` from the upstream project.

After installing `rbenv`, make sure it is initialized in your shell.

Check that it works:

```bash
rbenv --version
```

---

## 3. Install Ruby 2.6.5

From the repository:

```bash
rbenv install 2.6.5
```

If it is already installed, this step can be skipped.

Set Ruby 2.6.5 as the Ruby version for **this project only**:

```bash
rbenv local 2.6.5
```

This creates a `.ruby-version` file.

Verify:

```bash
ruby --version
```

You should see something similar to:

```text
ruby 2.6.5p114
```

Using `rbenv local` is preferable to changing your global Ruby version, since other projects may require newer Ruby versions.

---

## 4. Install the correct Bundler version

The project uses Bundler 1.17.2:

```bash
gem install bundler -v 1.17.2
```

Verify:

```bash
bundle _1.17.2_ --version
```

Expected:

```text
Bundler version 1.17.2
```

---

## 5. Install the Ruby dependencies

From the repository root:

```bash
bundle _1.17.2_ install
```

This installs the dependencies specified by the `Gemfile` and `Gemfile.lock`.

# 6. Set up the local database

The first time the application is started, Rails may report:

```text
ActiveRecord::PendingMigrationError
```

If so, run:

```bash
bundle _1.17.2_ exec rails db:migrate
```

You normally only need to do this once, unless new migrations are added.

---

# Start the application

Start the Rails development server:

```bash
bundle exec rails server
```

You should see something similar to:

```text
=> Booting Puma
=> Rails 5.1.7 application starting in development
* Version 4.3.12 (ruby 2.6.5-p114)
* Listening on tcp://127.0.0.1:3000
```

Open:

```text
http://localhost:3000
```