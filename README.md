# Docker container with PHP, SQL DB and nGinx

## Usage

* Add the following lines to your `.bashrc` file:

```sh
export UID
export GID=$(id -g)
```

* Create Docker pre-existing network:

```sh
docker network create g-network
```

> Find out more [here][0] about pre-existing networks.

* Copy `.env.dist` to `.env` file and fill your local config

* Run containers:

There two ways to run these components:

- by docker-compose (prod) `docker-compose -f docker-compose.yml up`
- by [docker-sync][1] (dev with code synchronization) `docker-sync-stack start`

> **Tip**
> Some containers map ports to a host port somewhere within an ephemeral port range in order to prevent the port
> collisions with already open ports, use command [docker port][3] to get the list port mappings. Find out more
> [here][3] about port bindings.

Enjoy!


### Useful commands

#### Backup and restore DB

Backup:

```bash
docker exec g-sql sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" gtats' > ../../backup.sql
```

Restore:

```bash
cat backup.sql | docker exec g-sql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" gtats'
```

Or:

```bash
mysql -h 172.26.0.2 -u root -pg-root9 gtats < ../../backup.sql
```

#### Compress/decompress composer libraries

```bash
tar cvf lib.tar vendor/composer/
```

```bash
tar -xvf lib.tar
```


[0]: https://docs.docker.com/compose/networking/#/using-a-pre-existing-network
[1]: http://docker-sync.io/
[3]: https://docs.docker.com/engine/reference/commandline/port/
[4]: https://docs.docker.com/engine/userguide/networking/default_network/binding/
