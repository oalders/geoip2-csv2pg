# 🔎 MaxMind CSV to Pg

The purpose of this repository is to make it easy to import MaxMind's
GeoLite2/GeoIP2 CSV databases into a local Docker 🐳 container which is running
PostgreSQL. This is meant to provide an easy way to query the CSV data in
PostgreSQL. It's not meant as a solution to deploy to production.

## 🚨 Please note:

- If you are on macOS, you will not need the `sudo` or `sudo -E` form of
the commands.
- If you don't want to pass the license key at the command line, create
  a file in the root of the repository called `.env` and add your key
  there.

A `.env` file would look like:

```shell
MM_LICENSE_KEY=SEEKRIT
```

## Step 1: Download the databases

Before you get started, edit the `DATABASES` variable in
`bin/download/download-db.sh`. The currently tested list of databases is:
`"GeoIP2-Anonymous-IP" "GeoLite2-City" "GeoIP2-Enterprise"`. Once you are happy
with this list you are ready to build the container.

### Build the Docker container which runs the downloader

```shell
sudo docker compose build mm-dl
```

### Download the CSV files

Run the following script, replacing the word `SEEKRIT` with a MaxMind license
key.

```shell
MM_LICENSE_KEY=SEEKRIT sudo -E docker compose up mm-dl
```

You may run this script as often as you like. It will download a database if
none exists locally or if there is a newer version available to download.

## Step 2: Build Your Docker Image

```shell
sudo docker compose build mm-pg
```

## Step 3: Run Your Docker Image

```shell
sudo docker compose up --remove-orphans mm-pg
```

## Step 4: Connect to PostgreSQL

If you have `psql` installed locally, use this command. When prompted for your password, enter "foo".

```shell
./bin/psql.sh
```

If you'd rather connect without a wrapper script, you can do something like:

```shell
psql -h localhost -U root -d mm_database
```

If you'd like to connect to the Docker container directly, get the Docker
container ID by running `docker ps`. You can then use the id in the following
command:

```shell
sudo docker compose exec mm-pg bash
```

Once you're inside the container, use the same command as above:

```shell
psql -h localhost -U root -d mm_database
```
