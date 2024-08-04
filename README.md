# Vulnerable Rails Application

A simple vulnerable Rails application and sequel to [hello-anya](https://github.com/quentinkhoo/hello-anya). Feel free to hack this :D

## Setup

First, change the default values within the `.env` file to whatever you'd like.

```bash
# rails env
RAILS_ENV=development

# routing and hosts
HOST=vuln-rails.com
TENANT1=tenant1
TENANT2=tenant2
SIEM=siem

# credentials / flag
TENANT1_EMAIL=tenant1@tenant1.vuln-rails.com
TENANT1_PASSWORD=tenant1_password
TENANT2_EMAIL=tenant2@tenant2.vuln-rails.com
FLAG=flag{this_is_a_real_flag}

# postgresql config
POSTGRES_USER=postgres_user
POSTGRES_PASSWORD=postgres_password
POSTGRES_DB=postgres_db
DATABASE_URL=postgresql://postgres_user:postgres_password@db:5432/postgres_db
```

Then, build and deploy it using `docker compose`:

```bash
git clone https://github.com/rouvinerh/vulnerable-rails
cd vulnerable-rails
docker compose build
docker compose up
```

The challenge starts at `http://tenant1.vuln-rails.com:3000`. Remember to add the host to the `/etc/hosts` file. Have fun!