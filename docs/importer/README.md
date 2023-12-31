# Importer

The importer component is responsible for downloading stream files uploaded by consensus nodes, verifying them, and
ingesting the normalized data into the database.

## Initialize Entity Balance

The importer tracks up-to-date entity balance by applying balance changes from crypto transfers. This relies on the
[InitializeEntityBalanceMigration](/hedera-mirror-importer/src/main/java/com/hedera/mirror/importer/migration/InitializeEntityBalanceMigration.java)
to set the correct initial entity balance from the latest account balance snapshot relative to the last record stream
file the importer has ingested and balance changes from crypto transfers not accounted in the snapshot. If the importer
is started with a database which doesn't meet the prerequisite (e.g., an empty database) or the entity balance is
inaccurate due to bugs, follow the steps below to re-run the migration to fix it.

1. Stop importer

2. Get the latest checksum of `InitializeEntityBalanceMigration`

   ```shell
   $ psql -h db -U mirror_node -c "select checksum from flyway_schema_history \
     where script like '%InitializeEntityBalanceMigration' order by installed_rank desc limit 1"
   ```

3. Set a different checksum (e.g., 2) for the migration and start importer

   ```yaml
   hedera:
     mirror:
       importer:
         migration:
           initializeEntityBalanceMigration:
             checksum: 2
   ```

## Performance Tests

The `RecordFileParserPerformanceTest` can be used to declaratively generate a `RecordFile` with different performance
characteristics and test how fast the importer can ingest them. To configure the performance test, populate the remote
database information and the test scenarios in an `application.yml`. Use the standard `hedera.mirror.importer.db`
properties to target the remote database. The below config is generating a mix of crypto transfer and contract calls
transactions at a combined 300 transactions per second (TPS) sustained for 60 seconds:

```yaml
hedera.mirror.importer.parser.record:
  performance:
    duration: 60s
    transactions:
      - entities: 10
        tps: 100
        type: CRYPTOTRANSFER
      - entities: 5
        tps: 200
        type: CONTRACTCALL
```

To run performance tests, use Gradle to run the `performanceTest` task. To run all performance tests omit the `tests`
parameter.

```console
./gradlew :importer:performanceTest --tests 'RecordFileParserPerformanceTest' --info
```

## Reconciliation Job

The reconciliation job verifies that the data within the stream files are in sync with each other and with the mirror
node database. This process runs once a day at midnight and produces logs, metrics, and alerts if reconciliation fails.

For each balance file, the job verifies it sums to 50 billion hbars. For every pair of balance files, it verifies the
aggregated hbar transfers in that period match what's expected in the next balance file. It also verifies the aggregated
token transfers match the token balance and that the NFT transfers match the expected NFT count in the balance file.

## Running importer for v2

For local testing the importer can be run using the following command:

```console
./gradlew :importer:bootRun --args='--spring.profiles.active=v2'
```

## Building the Citus docker images
Two images are created, manually as needed, and pushed to our [Docker Hub repository](https://hub.docker.com/repository/docker/mirrornodeswirldslabs/citus/general).
An enhanced Citus debian base image (amd64) is used to run Citus/Postgres in production and other environments in GCP.
In addition, a multi-platform alpine linux image is built in order to be used for local testing (arm64 on M-series Macs) and
Github CI workflows (amd64).

`DockerFile`s to build a custom image to be used in v2 is located in the following folder:
```hedera-mirror-node/hedera-mirror-importer/src/main/resources/db/scripts/v2/docker```

### Docker Hub details
The `mirrornodeswirldslabs` user was created just for this purpose. Therefore, when building the images below,
the tag contains `mirrornodeswirldslabs/citus` to indicate this repository, to which these images are later pushed.

The shared `mirrornode` 1Password vault contains the credentials for the Docker Hub `mirrornodeswirldslabs` user. This includes
an access token for the CLI as well as the TOTP configuration for MFA. You can use this to authenticate with
Docker Hub:

```console
docker login --username mirrornodeswirldslabs                                                                                                                  1 ↵
Password:
```
Copy and paste the token from 1Password.
```console
Login Succeeded

Logging in with your password grants your terminal complete access to your account.
For better security, log in with a limited-privilege personal access token. Learn more at https://docs.docker.com/go/access-tokens/
```
**NOTE:** Not sure why it still issues the above message when using the token instead of the password. It is a complete
access token though.

If you instead see this:
```console
Error saving credentials: error storing credentials - err: exit status 1, out: `ID hub token does not contain email`
```
You may need to restart Docker Desktop according to this [forum post](https://forums.docker.com/t/id-hub-token-does-not-contain-email/134608/2).

### Debian

The `debian` subdirectory contains the `Dockerfile` which defines the image used in production and other GCP based environments.
The Debian image is based directly on the Citus Debian image with a couple of additional Postgres extensions installed;
cron and partman. The resultant image is built only for the amd64 platform architecture. The standard `docker build`
command can be used to accomplish this.

The database name to be used by citus can be provided using an environment variable as follows:

```console
docker build --build-arg DB=mirror_node --platform linux/amd64 -t mirrornodeswirldslabs/citus:11.2.0 .
```

### Alpine

The `alpine` subdirectory contains the `Dockerfile` used to build the Citus image for use for both local development
on an M-series Mac (arm64) as well in the Github CI workflows (amd64). Thus, this image is built for both platform
architectures on top of a Postgres alpine base image. Citus and the additional Postgres extensions are compiled from
source code as part of this docker image build. Citus does not yet provide an image for arm64.

The instructions here pertain to building the multi-platform alpine image on an M-series Mac using Docker Desktop. Please refer to
[Multi-platform images](https://docs.docker.com/build/building/multi-platform/) for an overview on how to use Docker
Desktop to do this.

If you've not done so already since installing Docker Desktop, create a new builder:

```console
$ docker buildx create --name mybuilder --driver docker-container --bootstrap                                                                            1 ↵
mybuilder
[+] Building 12.6s (1/1) FINISHED
 => [internal] booting buildkit                                                                                                                          12.6s
 => => pulling image moby/buildkit:buildx-stable-1                                                                                                       11.9s
 => => creating container buildx_buildkit_mybuilder0
```

Switch to the new builder:
```console
$ docker buildx use mybuilder
```
Build the image for both amd64 (Github CI) and arm64 (local testing). Don't forget the '.' at the end of the line. This
can take some time depending on your internet speed. You will see activity around both arm64 and amd64.
```console
$ docker buildx build --build-arg DB=mirror_node --platform linux/arm64,linux/amd64 -t mirrornodeswirldslabs/citus:11.2.0-alpine .
[+] Building 351.1s (28/28) FINISHED
 => [internal] load .dockerignore                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                           0.0s
 => [internal] load build definition from Dockerfile                                                                                                      0.0s
 => => transferring dockerfile: 3.58kB
 ...
 => [linux/amd64  1/11] FROM docker.io/library/postgres:15.1-alpine@sha256:f19eede5a214c0933dce30c2e734b787b4c09193e874cce3b26c5d54b8b77ec7              18.2s
 ...
 => [linux/arm64  1/11] FROM docker.io/library/postgres:15.1-alpine@sha256:f19eede5a214c0933dce30c2e734b787b4c09193e874cce3b26c5d54b8b77ec7              28.0s
 WARNING: No output specified with docker-container driver. Build result will only remain in the build cache. To push result image into registry use --push or to load image into docker use --load
```
Again, this does not push the image. If you prefer, you can add `--push` to the command above and push the image at this time
rather than as a separate step below.

## Publishing the Citus docker images

If you did not utilize `--push` with `docker buildx` when building the alpine image, push it now to Docker Hub.
```console
docker push mirrornodeswirldslabs/citus:11.2.0-alpine
```
And for debian:
```console
docker push mirrornodeswirldslabs/citus:11.2.0
```
You can then see that the images have been updated in [the repository](https://hub.docker.com/repository/docker/mirrornodeswirldslabs/citus/general).
If you click on the tags you can see the OS/ARCH supported by each.
