# Invoice Ninja Docker Image
This set of files builds a docker image with everything needed to run a self-hosted invoice ninja instance locally. 😄

Get more information about this amazing app here: [Invoice Ninja](https://www.invoiceninja.org)

# INSTALLATION STEPS
## Build the image
Download all the files from this repository. If you want, modify some settings in the _.env_ file (such as SMTP settings, etc).

Once you're ready to go, issue the following command:

`docker build -t ninja .`

And that's really it! You can start/stop a container with this image in the usual way such as:

`docker run -dit --name ninja -p 8081:80 ninja`

and navigate to http://localhost:8081 in your browser to start using it, but beware the changes you make will be lost after shutdown.


## How to make changes persistent
Start container _without_ sharing volume. This will have an initialized mysql ninja DB

`docker run -dit --name ninja -p 8081:80 ninja`

When the container is running, copy contents of initialized DB into host:

`docker cp ninja:/var/lib/mysql/ D:\ninja1`

Of course use your own existing local folder here. ;-)
This will create a folder underneath the host machine's _D:\ninja1\mysql_ with the corresponding data so it can be persisted.

Shutdown and delete container:

`docker container stop ninja`

`docker container rm ninja`

From now on re-run container sharing the volume to persist data:

`docker run -dit --name ninja -p 8081:80 -v D:\ninja1\mysql:/var/lib/mysql/ ninja`

All changes will be saved locally in your host in the shared volume. 😉

# Connect interactively to the running container:

`docker exec -it ninja bash`

Use this if you need to check logs, mysql data, etc...

# How to backup/restore the image on Windows
Use these commands to save/load the image so you don't need to rebuild in the future:

`docker save -o image-file-name.tar ninja:latest`

`docker load -i "c:\path\to\image-file-name.tar"`

# How to backup/restore the image on Lunix (untested)

`docker save ninja:latest | gzip -c > image-file-name.tgz`

`gunzip -c image-file-name.tgz | docker load`

# Using PhantomJSCloud
No need to do anything out-of-the-box, this is here just for reference:

- If you are using the a-demo-key-with-low-quota-per-ip-address ApiKey, you are limited to 100 Pages/Day.
- If you exceed this creditBalance, you will get a HTTP Response Status 402 (Payment Required).
- Sign up for a Free Account and get 500 Pages/Day.

Check pricing here: [https://phantomjscloud.com/pricing.html](https://phantomjscloud.com/pricing.html)

# Using PhantomJS locally (untested)
Inside the running container install using:

`apt-get install phantomjs`

Add this key to /var/www/html/ninja/.env file:

_PHANTOMJS_BIN_PATH=/usr/local/bin/phantomjs_

Remove the key _PHANTOMJS_CLOUD_KEY_

Of course you'll need to resave the image if you want to be redeployable ([docker commit](https://docs.docker.com/engine/reference/commandline/commit/))

# Other notes (reference)
If no _.env_ file has been created under _/var/www/html/ninja/_ then need to add the main user.

Navigate to setup page (http://localhost:8081/setup) and configure using the correct password for SQL: _somep@ssw0rdForSQL_

Test connection, add the user and remember credentials.
