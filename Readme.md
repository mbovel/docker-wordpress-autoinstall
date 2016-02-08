Automatically download, configure, install and run [WordPress](https://wordpress.org) thanks to [WP-CLI](http://wp-cli.org).

**Warning**: WordPress is launched wih the [PHP's built-in web server](http://php.net/manual/en/features.commandline.webserver.php). It is not intended to be a full-featured web server. It should not be used on a public network.

## How to use it

### With docker compose

The simplest is to use [docker compose](https://docs.docker.com/compose/):

	docker-compose up -d

This launch two containers:

- `web`: the WordPress installation itself, from the `Dockerfile`,
- `db`: the [official mysql container](https://hub.docker.com/_/mysql/).

When you start the containers with `docker-compose`, you can adjust the configuration in the `.env` file (see “Environment Variables” for possible values).

### With docker engine
	
	gdocker build -t wp .
	docker run -d -e MYSQL_HOST=<host> -e MYSQL_USER=<username> -e MYSQL_PASSWORD=<password> -e MYSQL_DATABASE=<database for wordpress>

When you start the containers with `docker-compose`, you can set environment variables with `-e <NAME>=<VALUE>` parameters.

## Environment Variables

- `MYSQL_ROOT_PASSWORD`
- `MYSQL_HOST=db`: 
- `MYSQL_PORT=3306`: 
- `MYSQL_USER=root`
- `MYSQL_PASSWORD=root`
- `MYSQL_DATABASE=wp`
- `WORDPRESS_URL=wordpress`
- `WORDPRESS_TITLE=WordPress site`
- `WORDPRESS_ADMIN_USER=admin`
- `WORDPRESS_ADMIN_PASSWORD=admin`
- `WORDPRESS_ADMIN_MAIL=admin@example.com`

## Build arguments

- `WORDPRESS_VERSION=4.4.2`

## See also

- [docker-wordpress-wp-cli](https://github.com/conetix/docker-wordpress-wp-cli)
- [docker-wordpress-cli](https://github.com/KaiHofstetter/docker-wordpress-cli)
- [wordpress-docker-dev](https://github.com/gravityrail/wordpress-docker-dev)
- [docker-wpdev](https://github.com/dz0ny/docker-wpdev)

