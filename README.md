# PHP APM with Docker + PHP 7.3.0 + CodeIgniter 4.1 + Apache Web Server 2.4.25

Spins up a CodeIgniter 4.1  PHP APM  You will see web requests like this: https://a.cl.ly/Kouljgpr .

**What's already configured:**
- Containerized PHP APM with CodeIgniter 4.1


### Step 1: Create a custom .env file for your Datadog Keys.

Make sure that in your ~ directory, you have a file called sandbox.docker.env that contains:

```
DD_API_KEY=<Your API Key>
```

If you don't have it, create the file. If you have this already, skip this step. Now when you run the next steps, you don't have to worry about your API Key in plain text somehow making its way into the repo. If you really don't want to create this key, just add it to the docker-compose.yml file as an environment variable for the Datadog Agent.


### Step 2: Build the image

Have Docker running, then run this to build the images if you've made any changes to the Dockerfiles:

```
  docker-compose build --no-cache

```

Note:

1. If you get an error from getting the latest version:
```
Service 'web' failed to build: The command '/bin/sh -c get_latest_release() { wget -qO- "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/';} && DD_LATEST_PHP_VERSION="$(get_latest_release DataDog/dd-trace-php)" &&  wget -q https://github.com/DataDog/dd-trace-php/releases/download/${DD_LATEST_PHP_VERSION}/datadog-php-tracer_${DD_LATEST_PHP_VERSION}_amd64.deb && dpkg -i datadog-php-tracer_${DD_LATEST_PHP_VERSION}_amd64.deb' returned a non-zero code: 8
```

You can replace the last step manually by going to https://github.com/DataDog/dd-trace-php/releases/latest, finding the deb package you want and replacing the last RUN command with something like this:

```
RUN wget https://github.com/DataDog/dd-trace-php/releases/download/0.52.0/datadog-php-tracer_0.52.0_amd64.deb && dpkg -i datadog-php-tracer_0.52.0_amd64.deb

```


### Step 3: Spin up the containers:

Make any changes like PHP APM environment variables that you want to the docker-compose.yml file. Some useful ones to consider from the [configuration table](https://docs.datadoghq.com/tracing/setup_overview/setup/php/?tab=containers#environment-variable-configuration):

Once you're done, run this command to spin up the containers:


```
  docker-compose up
```

### Step 4: Generate traces from the App
Exec into the application container in a separate terminal

```
docker exec -it php_codeigniter_sandbox_web_1 bash 
```

cd into the application:

```
cd ci-news
```

Run the application with the following command:

```
php spark serve
```

Go to your browser and check for:

```
localhost:8080
```

Traces should appear in your sandbox

Note: Codeigniter is not supported for automatic instrumentation. Any method level calls will need to be custom instrumented in order to be seen in APM
### Step 6: Spin down containers

```
docker-compose down
```

