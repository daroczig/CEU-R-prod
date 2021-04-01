Here you can find the materials for the "[Data Engineering 5: Using R in Production](https://courses.ceu.edu/courses/2020-2021/data-engineering-5-using-r-production)" course, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous editions, see [2017/2018](https://github.com/daroczig/CEU-R-prod/tree/2017-2018), [2018/2019](https://github.com/daroczig/CEU-R-prod/tree/2018-2019), [2019/2020](https://github.com/daroczig/CEU-R-prod/tree/2019-2020).

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Schedule](#schedule)

    * [Background: Example use-cases and why to use R in the cloud?](#background-example-use-cases-and-why-to-use-r-in-the-cloud)
    * [Welcome to AWS!](#welcome-to-aws)
    * [Getting access to EC2 boxes](#getting-access-to-ec2-boxes)
    * [Create and connect to an EC2 box](#create-and-connect-to-an-ec2-box)
    * [Install RStudio Server on EC2](#install-rstudio-server-on-ec2)
    * [Connect to the RStudio Server](#connect-to-the-rstudio-server)
    * [Create a user for every member of the team](#create-a-user-for-every-member-of-the-team)
    * [Play with R for a bit](#play-with-r-for-a-bit)
    * [Prepare to schedule R commands](#prepare-to-schedule-r-commands)
    * [Schedule R commands](#schedule-r-commands)

* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class Schedule](#class-schedule)

* [Contact](#contact)

## Schedule

2 x 3 x 100 mins on March 23 and 30:

* 13:30 - 15:00 session 1
* 15:00 - 15:30 break
* 15:30 - 17:00 session 2
* 17:00 - 17:30 break
* 17:30 - 19:00 session 3

## Location

This class will take place online. Find the Zoom URL shared in Moodle.

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

1. You need a laptop with any operating system and stable Internet connection.
2. Please make sure that network firewall rules are not limiting your access to unusual ports (e.g. 22, 8787, 8080, 8000), as we will heavily use these in the class (can be a problem on a company network).
3. Please install Slack, and join the #﻿ba-de5-2020 channel in the `ceu-bizanalytics` group.
4. Highly suggested to get a second monitor where you can follow the online stream, and keep your main monitor for your own work. The second monitor could be an external screen attached to your laptop, e.g. a TV, monitor, projector, but if you don't have access to one, you may also use a table or phone to dial-in to the Zoom call.

## Class Schedule

Will be updated from week to week.

## Week 1

**Goal**: learn how to run and schedule R jobs in the cloud.

### Background: Example use-cases and why to use R in the cloud?

* http://bit.ly/budapestdata-2018-dbs-in-a-startup (presented at the [Budapest Data Forum in 2018](https://budapestdata.hu/2018/hu/))
* http://bit.ly/daroczig-rstudio-conf-2020 (presented at the [RStudio::conf in 2020](https://web.cvent.com/event/36ebe042-0113-44f1-8e36-b9bc5d0733bf))

### Welcome to AWS!

1. Use the central CEU AWS account: https://ceu.signin.aws.amazon.com/console
2. Secure your access key(s), other credentials and any login information ...

    <details><summary>... because a truly wise person learns from the mistakes of others!</summary>

    > "When I woke up the next morning, I had four emails and a missed phone call from Amazon AWS - something about 140 servers running on my AWS account, mining Bitcoin"
    -- [Hoffman said](https://www.theregister.co.uk/2015/01/06/dev_blunder_shows_github_crawling_with_keyslurping_bots)

    > "Nevertheless, now I know that Bitcoin can be mined with SQL, which is priceless ;-)"
    -- [Uri Shaked](https://medium.com/@urish/thank-you-google-how-to-mine-bitcoin-on-googles-bigquery-1c8e17b04e62)

    So set up 2FA (go to IAM / Users / username / Security credentials / Assigned MFA device): https://console.aws.amazon.com/iam

    PS probably you do not really need to store any access keys, but you may rely on roles (and the Key Management Service, and the Secrets Manager and so on)
    </details>

3. Let's use the `eu-west-1` Ireland region

### Getting access to EC2 boxes

**Note**: we follow the instructions on Windows in the Computer Lab, but please find below how to access the boxes from Mac or Linux as well when working with the instances remotely.

1. Create (or import) an SSH key in AWS (EC2 / Key Pairs): https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName
2. Get an SSH client:

    * Windows -- Download and install PuTTY: https://www.putty.org
    * Mac -- Install PuTTY for Mac using homebrew or macports

        ```sh
        sudo brew install putty
        sudo port install putty
        ```

    * Linux -- probably the OpenSSH client is already installed, but to use the same tools on all operating systems, please install and use PuTTY on Linux too, eg on Ubuntu:

        ```sh
        sudo apt install putty
        ```

3. ~~Convert the generated pem key to PuTTY format~~No need to do this anymore, AWS can provide the key as PPK now.

    * GUI: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html#putty-private-key
    * CLI:

        ```sh
        puttygen key.pem -O private -o key.ppk
        ```

4. Make sure the key is readable only by your Windows/Linux/Mac user, eg

    ```sh
    chmod 0400 key.ppk
    ```

### Create and connect to an EC2 box

1. Create a tiny EC2 instance

    0. Optional: create an Elastic IP for your box
    1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
    2. Click "Launch Instance"
    3. Pick the `Ubuntu Server 20.04 LTS (HVM), SSD Volume Type` AMI
    4. Pick `t3.micro` instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
    5. Click "Review and Launch"
    6. Pick a unique name for the security group after clicking "Edit Security Group"
    7. Click "Launch"
    8. Select your AWS key created above and launch

2. Connect to the box

    1. Specify the hostname or IP address

    ![](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/images/vm-putty-1.png)

    2. Specify the key for authentication

    ![](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/images/vm-putty-2.png)

    3. Set the username to `ubuntu` on the Connection/Data tab
    4. Save the Session profile
    5. Click the "Open" button
    6. Accept & cache server's host key

Alternatively, you can connect via a standard SSH client on a Mac or Linux, something like:

```sh
chmod 0400 /path/to/your/pem
ssh -i /path/to/your/pem -p 8000 ubuntu@ip-address-of-your-machine
```

### Install RStudio Server on EC2

1. Look at the docs: https://www.rstudio.com/products/rstudio/download-server
2. Download Ubuntu `apt` package list

    ```sh
    sudo apt update
    ```

3. Install dependencies

    ```sh
    sudo apt install r-base gdebi-core
    ```

4. Try R

    ```sh
    R
    ```

    For example:

    ```r
    1 + 4
    hist(mtcars$hp)
    ```

5. Install RStudio Server

    ```sh
    wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
    sudo gdebi rstudio-server-1.4.1106-amd64.deb
    ```

6. Check process and open ports

    ```sh
    rstudio-server status
    sudo rstudio-server status
    sudo systemctl status rstudio-server
    sudo ps aux| grep rstudio
    sudo netstat -tapen | grep LIST
    sudo netstat -tapen
    ```

7. Look at the docs: http://docs.rstudio.com/ide/server-pro/

### Connect to the RStudio Server

1. Confirm that the service is up and running and the port is open

    ```console
    ubuntu@ip-172-31-12-150:~$ sudo netstat -tapen | grep LIST
    tcp        0      0 0.0.0.0:8787            0.0.0.0:*               LISTEN      0          49065       23587/rserver
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          15671       1305/sshd
    tcp6       0      0 :::22                   :::*                    LISTEN      0          15673       1305/sshd
    ```

2. Try to connect to the host from a browser on port 8787, eg http://foobar.eu-west-1.compute.amazonaws.com:8787
3. Realize it's not working
4. Open up port 8787 in the security group

    ![](https://d2908q01vomqb2.cloudfront.net/b6692ea5df920cad691c20319a6fffd7a4a766b8/2017/10/12/r-update-1.gif)

5. Authentication: http://docs.rstudio.com/ide/server-pro/authenticating-users.html
6. Create a new user:

        sudo adduser ceu

7. Login & quick demo:

    ```r
    1+2
    plot(mtcars)
    install.packages('fortunes')
    library(fortunes)
    fortune()
    fortune(200)
    system('whoami')
    ```

8. Reload webpage (F5), realize we continue where we left the browser :)
9. Demo the terminal:

    ```console
    $ whoami
    ceu
    $ sudo whoami
    ceu is not in the sudoers file.  This incident will be reported.
    ```

8. Grant sudo access to the new user by going back to SSH with `root` access:

    ```sh
    sudo apt install -y mc
    sudo mc
    sudo mcedit /etc/sudoers
    sudo adduser ceu admin
    man adduser
    man deluser
    ```

Note 1: might need to relogin / restart RStudio / reload R / reload page
Note 2: you might want to add `NOPASSWD` to the `sudoers` file:

    ```sh
    ceu ALL=(ALL) NOPASSWD:ALL
    ```

Although also note (3) the related security risks.

9. Custom login page: http://docs.rstudio.com/ide/server-pro/authenticating-users.html#customizing-the-sign-in-page
10. Custom port: http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

### Play with R for a bit

1. Installing packages:

    ```sh
    ## don't do this at this point!
    ## install.packages('ggplot2')
    ```

2. Use binary packages instead via apt & Launchpad PPA:

    ```sh
    sudo add-apt-repository ppa:marutter/rrutter
    sudo add-apt-repository ppa:marutter/c2d4u

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install r-cran-ggplot2
    ```

3. Ready to use it from R after restarting the session:

    ```r
    library(ggplot2)
    ggplot(mtcars, aes(hp)) + geom_histogram()
    ```

4. Get some real-time data and visualize it:

    1. Install the `devtools` R package and a few others (binary distribution) in the RStudio/Terminal:

        ```sh
        sudo apt-get install r-cran-devtools r-cran-data.table r-cran-httr r-cran-jsonlite r-cran-data.table r-cran-stringi r-cran-stringr r-cran-glue
        ```

    2. Switch back to the R console and install the `binancer`  R package from GitHub to interact with crypto exchanges (note the extra dependency to be installed from CRAN):

        ```r
        install.packages('snakecase')
        devtools::install_github('daroczig/binancer', upgrade_dependencies = FALSE)
        ```

    3. First steps with live data: load the `binancer` package and then use the `binance_klines` function to get the last 3 hours of Bitcoin price changes (in USD) with 1-minute granularity -- resulting in an object like:

        ```r
        > str(klines)
        Classes ‘data.table’ and 'data.frame':  180 obs. of  12 variables:
         $ open_time                   : POSIXct, format: "2020-03-08 20:09:00" "2020-03-08 20:10:00" "2020-03-08 20:11:00" "2020-03-08 20:12:00" ...
         $ open                        : num  8292 8298 8298 8299 8298 ...
         $ high                        : num  8299 8299 8299 8299 8299 ...
         $ low                         : num  8292 8297 8297 8298 8296 ...
         $ close                       : num  8298 8298 8299 8298 8299 ...
         $ volume                      : num  25.65 9.57 20.21 9.65 24.69 ...
         $ close_time                  : POSIXct, format: "2020-03-08 20:09:59" "2020-03-08 20:10:59" "2020-03-08 20:11:59" "2020-03-08 20:12:59" ...
         $ quote_asset_volume          : num  212759 79431 167677 80099 204883 ...
         $ trades                      : int  371 202 274 186 352 271 374 202 143 306 ...
         $ taker_buy_base_asset_volume : num  13.43 5.84 11.74 7.12 15.24 ...
         $ taker_buy_quote_asset_volume: num  111430 48448 97416 59071 126493 ...
         $ symbol                      : chr  "BTCUSDT" "BTCUSDT" "BTCUSDT" "BTCUSDT" ...
         - attr(*, ".internal.selfref")=<externalptr>
        ```

        <details><summary>Click here for the code generating the above ...</summary>

        ```r
        library(binancer)
        klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
        str(klines)
        summary(klines$close)
        ```
        </details>

    4. Visualize the data, eg on a simple line chart:

        ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-1.png)

        <details><summary>Click here for the code generating the above ...</summary>

        ```r
        library(ggplot2)
        ggplot(klines, aes(close_time, close)) + geom_line()
        ```
        </details>

    5. Now create a candle chart, something like:

        ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-2.png)

        <details><summary>Click here for the code generating the above ...</summary>

        ```r
        library(scales)
        ggplot(klines, aes(open_time)) +
            geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
            geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
            theme_bw() + theme('legend.position' = 'none') + xlab('') +
            ggtitle(paste('Last Updated:', Sys.time())) +
            scale_y_continuous(labels = dollar) +
            scale_color_manual(values = c('#1a9850', '#d73027')) # RdYlGn
        ```
        </details>

    6. Compare prices of 4 currencies (eg ETH, ARK, NEO and IOTA) in the past 24 hours on 15 mins intervals:

        ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-3.png)

        <details><summary>Click here for the code generating the above ...</summary>

        ```r
        library(data.table)
        klines <- rbindlist(lapply(
            c('ETHBTC', 'ARKBTC', 'NEOBTC', 'IOTABTC'),
            binance_klines,
            interval = '15m', limit = 4*24))
        ggplot(klines, aes(open_time)) +
            geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
            geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
            theme_bw() + theme('legend.position' = 'none') + xlab('') +
            ggtitle(paste('Last Updated:', Sys.time())) +
            scale_color_manual(values = c('#1a9850', '#d73027')) +
             facet_wrap(~symbol, scales = 'free', nrow = 2)
        ```
        </details>

    7. Some further useful functions:

        - `binance_ticker_all_prices()`
        - `binance_coins_prices()`
        - `binance_credentials` and `binance_balances`

    8. Create an R script that reports and/or plots on some cryptocurrencies, ideas:

        - compute the (relative) change in prices of cryptocurrencies in the past 24 / 168 hours
        - go back in time 1 / 12 / 24 months and "invest" $1K in BTC and see the value today
        - write a bot buying and selling crypto on a virtual exchange

#### Create a user for every member of the team

We'll export the list of IAM users from AWS and create a system user for everyone.

1. Attach a newly created IAM EC2 Role (let's call it `ceudataserver`) to the EC2 box and assign 'Read-only IAM access':

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-type.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-rights.png)

2. Install AWS CLI tool:

    ```
    sudo apt update
    sudo apt install awscli
    ```

3. List all the IAM users: https://docs.aws.amazon.com/cli/latest/reference/iam/list-users.html

   ```
   aws iam list-users
   ```

4. Export the list of users from R:

   ```
   library(jsonlite)
   users <- fromJSON(system('aws iam list-users', intern = TRUE))
   str(users)
   users[[1]]$UserName
   ```

5. Create a new system user on the box (for RStudio Server access) for every IAM user, set password and add to group:

   ```
   library(logger)
   library(glue)
   for (user in users[[1]]$UserName) {

     ## remove invalid character
     user <- sub('@.*', '', user)
     user <- sub('.', '_', user, fixed = TRUE)

     log_info('Creating {user}')
     system(glue("sudo adduser --disabled-password --quiet --gecos '' {user}"))

     log_info('Setting password for {user}')
     system(glue("echo '{user}:secretpass' | sudo chpasswd")) # note the single quotes + placement of sudo

     log_info('Adding {user} to sudo group')
     system(glue('sudo adduser {user} sudo'))

   }
   ```

Note, you may have to temporarily enable passwordless `sudo` for this user (if have not done already) :/

```
ceu ALL=(ALL) NOPASSWD:ALL
```

Check users:

```
readLines('/etc/passwd')
```

### Prepare to schedule R commands

![](https://wiki.jenkins-ci.org/download/attachments/2916393/fire-jenkins.svg)

1. Install Jenkins from the RStudio/Terminal: https://pkg.jenkins.io/debian-stable/

    ```sh
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list
    sudo apt update
    sudo apt install openjdk-8-jdk-headless jenkins ## installing Java as well
    sudo netstat -tapen | grep java
    ```

2. Open up port 8080 in the related security group
3. Access Jenkins from your browser and finish installation

    1. Read the initial admin password from RStudio/Terminal via

        ```sh
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
        ```

    2. Proceed with installing the suggested plugins
    3. Create your first user (eg `ceu`)

4. Optionally update the security backend to use real Unix users for shared access (if users already created):

    ```sh
    sudo adduser jenkins shadow
    sudo systemctl restart jenkins
    ```

5. Test new user access in an incognito window to avoid closing yourself out :)

### Schedule R commands

Let's schedule a Jenkins job to check on the Bitcoin prices every hour!

1. Log in to Jenkins using your instance's public IP address and port 8080
2. Use the `ceu` username and `ceudata` password
3. Create a "New Item" (job):

    1. Enter the name of the job: `get current Bitcoin price`
    2. Pick "Freestyle project"
    3. Click "OK"
    4. Add a new "Execute shell" build step
    5. Enter the below command to look up the most recent BTC price

        ```sh
        R -e "library(binancer);binance_coins_prices()[symbol == 'BTC', usd]"
        ```

    6. Run the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/jenkins-errors.png)

4. Debug & figure out what's the problem ...
5. Install R packages system wide from RStudio/Terminal (more on this later):

    ```sh
    sudo Rscript -e "library(devtools);with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/binancer', upgrade_dependencies = FALSE))"
    ```

6. Rerun the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2018-2019/images/jenkins-success.png)

7. Optionally set up E-mail and Slack notification for the job success/error:

    1. Scroll down in the job config to the "Post-build Actions" section
    2. Add "Editable email notification", then fill in the "Project Recipient List" with an email address, and click "Advanced Settings" to define the triggers (e.g. send email on success or failure, and if you want to attach anything to the email).
    3. Add "Slack notifications" and configure the triggers, all the other details (e.g. which Slack channel to report to and Slack username etc have been configured globally, so although you can override, but no need to).

### Homework

Read the [rOpenSci Docker tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) -- quiz next week! Think about why we might want to use Docker.

## Week 2

### Recap

What we convered last week:

1. 2FA/MFA in AWS
2. Creating EC2 nodes
3. Connecting to EC2 nodes via SSH/Putty (note the difference between the PPK and PEM key formats)
4. Updating security groups
5. Installing RStudio Server
6. The difference between R console and Shell
7. The use of `sudo` and how to grant `root` (system administrator) privileges
8. Adding new Linux users, setting password, adding to group
9. Installing R packages system-wide VS in the user's home folder
10. Installing, setting up and first steps with Jenkins

Note the above detailed steps for the above!

Also, in the below steps, you can skip running all the instructions prefixed with 💪 -- as the Amazon AMI has already configured so for your convenience, and these steps are just here as an FYI if you want to reproduce the same environment later (eg for a hobby project or work).

### Docker Quiz

Please fill in the form at https://goo.gl/forms/oKQ0zILuQljgBxyH3

### Preparations

0. All infra steps are optional today and feel free to use the shared RStudio and Jenkins server!
1. Log in to the central CEU AWS account: https://ceu.signin.aws.amazon.com/console
2. Did you use 2FA / MFA?!
3. Use the Ireland region
4. Go to the EC2 console at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
5. Realize the mess we left there from last week! 😱 Fix it. Kill your old security groups as well. Remove unneeded keys.
6. 💪 Check on the wasted money in the AWS Cost Explorer
7. Create a new `t3.micro` instance using the `de5-week2` AMI, `t3.small` instance size, `de5-week2` IAM role and the `de5-week2` security group that latter is opening up the 22 (ssh), 8787 (rstudio) and 8080 (jenkins) ports
8. Log in to RStudio using the new instance's public IP address and 8787 port, then your AWS username (without domain) and the password from last week (ping on Slack if cannot find it)
9. Check if the price of a Bitcoin is more than $1,000,000 (feel free to scroll up to get some hints from last week's R scripts)

### 💪 Set up an easy to remember IP address

Optionally you can associate a fixed IP address to your box:

1. Allocate a new Elastic IP address at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Addresses:
2. Name this resource by assigning a "Name" tag
3. Associate this Elastic IP with your stopped box, then start it

### 💪 Set up an easy to remember domain name

Optionally you can associate a subdomain with your node, using the above created Elastic IP address:

1. Go to Route 53: https://console.aws.amazon.com/route53/home
2. Go to Hosted Zones and click on `ceudata.net`
3. Create a new Record, where

    - fill in the desired `Name` (subdomain), eg `gergely.ceudata.net`
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create`

4. Now you will be able to access your box using this custon (sub)domain, no need to remember IP addresses.

### 💪 Configuring for standard ports

To avoid using ports like `8787` and `8080`, let's configure our services to listen on the standard 80 (HTTP) and potentially on the 443 (HTTPS) port as well, and serve RStudio on the `/rstudio`, and Jenkins on the `/jenkins` path.

For this end, we will use Nginx as a reverse-proxy, so let's install it first:

```shell
sudo apt install -y nginx
```

First, we need to edit the Nginx config to enable websockets for Shiny apps etc in `/etc/nginx/nginx.conf`:

```
  map $http_upgrade $connection_upgrade {
      default upgrade;
      ''      close;
    }
```

Then we need to edit the main site's configuration at `/etc/nginx/sites-enabled/default` to act as a proxy, which also do some transformations, eg rewriting the URL (removing the `/rstudio` path) before hitting RStudio Server:

```
server {
    listen 80;
    rewrite ^/rstudio$ $scheme://$http_host/rstudio/ permanent;
    location /rstudio/ {
      rewrite ^/rstudio/(.*)$ /$1 break;
      proxy_pass http://localhost:8787;
      proxy_redirect http://localhost:8787/ $scheme://$http_host/rstudio/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_read_timeout 20d;
    }
}
```

And restart Nginx:

```shell
sudo systemctl restart nginx
```

Find more information at https://support.rstudio.com/hc/en-us/articles/200552326-Running-RStudio-Server-with-a-Proxy.

Let's see if the port is open on the machine:

```shell
sudo netstat -tapen|grep LIST
```

Let's see if we can access RStudio Server on the new path:

```shell
curl localhost/rstudio
```

Now let's see from the outside world ... and realize that we need to open up port 80!

Now we need to tweak the config to support Jenkins as well, but the above Nginx rewrite hack will not work (see https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-troubleshooting/ for more details), so we will just make it a standard reverse-proxy, eg:

```
server {
    listen 80;
    rewrite ^/rstudio$ $scheme://$http_host/rstudio/ permanent;
    location /rstudio/ {
      rewrite ^/rstudio/(.*)$ /$1 break;
      proxy_pass http://localhost:8787;
      proxy_redirect http://localhost:8787/ $scheme://$http_host/rstudio/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_read_timeout 20d;
    }
    location ^~ /jenkins/ {
        proxy_pass http://127.0.0.1:8080/jenkins/;
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
    }
}
```

And we also need to let Jenkins also know about the custom path, so edit the `JENKINS_ARGS` config in `/etc/default/jenkins` by adding:

```shell
--prefix=/jenkins
```

Then restart Jenkins, and good to go!

This way you can access the above services via the below URLs:

RStudio Server:

* http://your.ip.address:8080
* http://your.ip.address/rstudio

Jenkins:

* http://your.ip.address:8000/jenkins
* http://your.ip.address/jenkins

If you cannot access RStudio Server on port 80, you might need to restart `nginx` as per above.

Next, set up SSL either with Nginx or placing an AWS Load Balancer in front of the EC2 node.

### 💪 ScheduleR improvements

1. Learn about little R: https://github.com/eddelbuettel/littler
2. Set up e-mail notifications via eg mailjet.com

    1. Sign up, confirm your e-mail address and domain
    2. Take a note on the SMTP settings, eg

        * SMTP server: in-v3.mailjet.com
        * Port: 465
        * SSL: Yes
        * Username: ***
        * Password: ***

    3. Configure Jenkins at http://SERVERNAME.ceudata.net:8080/configure

        1. Set up the default FROM e-mail address: jenkins@ceudata.net
        2. Search for "Extended E-mail Notification" and configure

           * SMTP Server
           * Click "Advanced"
           * Check "Use SMTP Authentication"
           * Enter User Name from the above steps from SNS
           * Enter Password from the above steps from SNS
           * Check "Use SSL"
           * SMTP port: 465

    5. Set up "Post-build Actions" in Jenkins: Editable Email Notification - read the manual and info popups, configure to get an e-mail on job failures and fixes
    6. Configure the job to send the whole e-mail body as the deault body template for all outgoing emails

    ```shell
    ${BUILD_LOG, maxLines=1000}
    ```

3. Look at other Jenkins plugins, eg the Slack Notifier: https://plugins.jenkins.io/slack

### Schedule R scripts

1. Create an R script with the below content and save on the server, eg as `/home/ceu/bitcoin-price.R`:

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    sprintf('The current Bitcoin price is: %s', prices[symbol == 'BTC', usd])
    ```

2. Follow the steps from the [Schedule R commands](#schedule-r-commands) section to create a new Jenkins job, but instead of calling `R -e "..."` in shell step, reference the above R script using `Rscript` instead

    ```shell
    r /home/ceu/de4.R
    ```

### Intro to redis

We need a persistent storage for our Jenkins jobs ... let's give a try to a key-value database:

1. 💪 Install server

   ```
   sudo apt install redis-server
   netstat -tapen | grep LIST
   ```

2. 💪 Install client

    ```
    sudo Rscript -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('rredis', repos='https://cran.rstudio.com/'))"
    ```

3. Interact from R

    ```r
    ## set up and initialize the connection to the local redis server
    library(rredis)
    redisConnect()

    ## set/get values
    redisSet('foo', 'bar')
    redisGet('foo')

    ## increment and decrease counters
    redisIncr('counter')
    redisIncr('counter')
    redisIncr('counter')
    redisGet('counter')
    redisDecr('counter')
    redisDecr('counter2')

    ## get multiple values at once
    redisMGet(c('counter', 'counter2'))

    ## list all keys
    redisKeys()
    ```

For more examples and ideas, see the [`rredis` package vignette](https://cran.r-project.org/web/packages/rredis/vignettes/rredis.pdf) or try the interactive, genaral (not R-specific) [redis tutorial](https://try.redis.io).

4. Exercises

    - Create a Jenkins job running every minute to cache the most recent Bitcoin and Ethereum prices in Redis
    - Write an R script in RStudio that can read the Bitcoin and Ethereum prices from the Redis cache

<details><summary>Example solution ...</summary>

```r
library(rredis)
redisConnect()

redisSet('price:BTC', binance_klines('BTCUSDT', interval = '1m', limit = 1)$close)
redisSet('price:ETH', binance_klines('ETHUSDT', interval = '1m', limit = 1)$close)

redisGet('price:BTC')
redisGet('price:ETH')

redisMGet(c('price:BTC', 'price:ETH'))
```
</details>

<details><summary>Example solution using a helper function doing some logging ...</summary>

```r
library(binancer)
library(logger)
library(rredis)
redisConnect()

store <- function(symbol) {
  log_info('Looking up and storing {symbol}')
  key <- paste('price', symbol, sep = ':')
  value <- binance_klines(paste0(symbol, 'USDT'), interval = '1m', limit = 1)$close
  redisSet(key, value)
  log_info('The price of {symbol} is {value}')

}

store('BTC')
store('ETH')

## list all keys with the "price" prefix and lookup the actual values
redisMGet(redisKeys('price:*'))
```
</details>

More on databases at the "Mastering R" class in the Spring semester ;)

### Interacting with Slack

1. Join the #ba-de5-2020-bots channel in the `ceu-bizanalytics` Slack
2. 💪 A custom Slack app is already created at https://api.slack.com/apps/A9FBHCLPR, but feel free to create a new one and use the related app in the following steps
3. Look up the app's bots in the sidebar
4. Look up the Access Token

#### 💪 Using Slack from Jenkins

1. Get familiar with the Slack Notifier Jenkins plugin: https://plugins.jenkins.io/slack
2. Configure global Slack options (what about storing the token?)
3. Set up post-hook actions to alert in Slack if a Jenkins job is failing

#### Talk: Productionizing R in the Cloud

Slides at http://bit.ly/satrday-la-2018-daroczig

#### Note on storing the Slack token

1. Do not store the token in plain-text!
2. Let's use Amazon's Key Management Service: https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (slides 73-75)
3. 💪 Instead of using the Java SDK referenced in the above talk, let's install `boto3` Python module and use via `reticulate`:

    ```shell
    sudo apt install python3-pip
    sudo pip3 install boto3
    sudo apt install r-cran-reticulate
    sudo Rscript -e "library(devtools);withr::with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/botor', upgrade = FALSE))"
    ```

4. 💪 Create a KMS key in IAM: `alias/de5`
5. Grant access to that KMS key by creating an EC2 IAM role at https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles with the `AWSKeyManagementServicePowerUser` policy and explicit grant access to the key in the KMS console
6. Attach the newly created IAM role
7. Use this KMS key to encrypt the Slack token:

    ```r
    library(botor)
    botor(region = 'eu-west-1')
    kms_encrypt('token', key = 'alias/de5')
    ```

8. Store the ciphertext and use `kms_decrypt` to decrypt later, see eg

    ```r
    kms_decrypt("AQICAHhh7Ku/BWdSbCqos9k49Vnk1+WytvoesgX+1bOvLAlyegHa210D93pgytNnThR9qVVxAAAAmjCBlwYJKoZIhvcNAQcGoIGJMIGGAgEAMIGABgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKkH9le72xKmMsgjTQIBEIBT/7MbIV2sG6Hh+fb8BJQ9a6VNOZ1rhPAgvSET6IUdiki92fMZ6dDBOpmSSuaa3t8KIF9KtrlbQAYQNtPVHUvFl1GpyM0k8bD7jLSsUPeRjFNoI+Q=")
    ```

9. 💪 Alternatively, use the AWS Parameter Store or Secrets Manager, see eg https://eu-west-1.console.aws.amazon.com/systems-manager/parameters/?region=eu-west-1&tab=Table and granting the `AmazonSSMReadOnlyAccess` policy to your IAM role or user.

#### Using Slack from R

4. 💪 Install the Slack R client

    ```shell
    sudo apt install r-cran-rlang r-cran-purrr r-cran-tibble r-cran-dplyr r-cran-httr r-cran-rlang
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('slackr', repos='https://cran.rstudio.com/'))"
    ```

5. Init and send our first messages with `slackr`

    ```r
    library(botor)
    botor(region = 'eu-west-1')
    token <- ssm_get_parameter('slack')
    library(slackr)
    slackr_setup(username = 'jenkins', bot_user_oauth_token = token, icon_emoji = ':jenkins-rage:')
    slackr_msg(text = 'Hi there!', channel = '#ba-de5-2020-bots')
    ```

6. A more complex message

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    msg <- sprintf(':money_with_wings: The current Bitcoin price is: $%s', prices[symbol == 'BTC', usd])
    slackr_msg(text = msg, preformatted = FALSE, channel = '#ba-de5-2020-bots')
    ```

7. Or plot

    ```r
    library(ggplot2)
    klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
    p <- ggplot(klines, aes(close_time, close)) + geom_line()
    ggslackr(plot = p, channels = '#ba-de5-2020-bots', width = 12)
    ```

### Job Scheduler exercises

* Create a Jenkins job to alert if Bitcoin price is below $3.8K or higher than $4K
* Create a Jenkins job to alert if Bitcoin price changed more than $200 in the past hour
* Create a Jenkins job to alert if Bitcoin price changed more than 5% in the past day
* Create a Jenkins job running hourly to generate a candlestick chart on the price of BTC and ETH

<details><summary>Example solution for the first exercise ...</summary>

```r
## get data right from the Binance API
library(binancer)
btc <- binance_klines('BTCUSDT', interval = '1m', limit = 1)$close

## or from the local cache (updated every minute from Jenkins as per above)
library(rredis)
btc <- redisGet('price:BTC')

## log whatever was retreived
library(logger)
log_info('The current price of a Bitcoin is ${btc}')

## send alert
if (btc < 3800 | btc > 4000) {
  library(botor)
  token <- ssm_get_parameter('slack')
  library(slackr)
  slackr_setup(username = 'jenkins', bot_user_oauth_token = token, icon_emoji = ':jenkins-rage:')
  slackr_msg(
    text = paste('uh ... oh... BTC price:', btc),
    channel = '#ba-de4-2019-bots')
}
```

</details>


### Background: Example use-case and why to use R to do stream processing?

https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (presented at the Big Data Day Los Angeles 2016, EARL 2016 London and useR! 2017 Brussels)

### 💪 Setting up a demo stream

This section describes how to set up a Kinesis stream with 5 shards on the live Binance transactions read from its websocket -- running in a Docker container, then feeding the JSON lines to Kinesis via the Amazon Kinesis Agent.

1. Start a `t3.micro` instance running "Amazon Linux 2 AMI" (where it's easier to install the Kinesis Agent compared to using eg Ubuntu) with a known key. Make sure to **set a name** and enable termination protection (in the instance details)! Use SSH, Putty or eg the browser-based SSH connection.

2. Install Docker (note that we are not on Ubuntu today, but using Red Hat's `yum` package manager):

    ```
    sudo yum install docker
    sudo service docker start
    sudo service docker status
    ```

3. Let's use a small Python app relying on the Binance API to fetch live transactions and store in a local file:

    * sources: https://github.com/daroczig/ceu-de3-docker-binance-streamer
    * docker: https://cloud.docker.com/repository/registry-1.docker.io/daroczig/ceu-de3-docker-binance-streamer

    Usage:

    ```
    screen -RRd streamer
    sudo docker run -ti --rm  daroczig/ceu-de3-docker-binance-streamer > /tmp/transactions.json
    ## "C-a c" to create a new screen, then you can switch with C-a "
    ls -latr /tmp
    tail -f /tmp/transactions.json
    ```

4. Install the Kinesis Agent:

    As per https://docs.aws.amazon.com/firehose/latest/dev/writing-with-agents.html#download-install:

    ```
    sudo yum install -y aws-kinesis-agent
    ```

5. Create a new Kinesis Stream (called `crypto`) at https://eu-west-1.console.aws.amazon.com/kinesis

6. Configure the Kinesis Agent:

    ```
    sudo yum install mc
    sudo mcedit /etc/aws-kinesis/agent.json
    ```

    Running the above commands, edit the config file to update the Kinesis endpoint, the name of the stream on the local file path:

    ```
    {
      "cloudwatch.emitMetrics": true,
      "kinesis.endpoint": "https://kinesis.eu-west-1.amazonaws.com",
      "firehose.endpoint": "",

      "flows": [
        {
          "filePattern": "/tmp/transactions.json",
          "kinesisStream": "crypto",
          "partitionKeyOption": "RANDOM"
        }
      ]
    }
    ```

7. Restart the Agent:

    ```
    sudo service aws-kinesis-agent start
    ```

8. Check the status and logs:

    ```
    sudo service aws-kinesis-agent status
    sudo journalctl -xe
    ls -latr /var/log/aws-kinesis-agent/aws-kinesis-agent.log
    tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
    ```

9. Make sure that the IAM role (eg `kinesis-admin`) can write to Kinesis and Cloudwatch, eg by attaching the `AmazonKinesisFullAccess` policy, then restart the agent

    ```
    sudo service aws-kinesis-agent restart
    ```

10. Check the AWS console's monitor if all looks good there as well
11. Note for the need of permissions to `cloudwatch:PutMetricData` (see example `cloudwatch-putmetrics` policy).

### A simple stream consumer app in R

As the `botor` package was already installed, we can rely on the power of `boto3` to interact with the Kinesis stream. The IAM role attached to the node already has the `AmazonKinesisFullAccess` policy attached, so we have permissions to read from the stream.

First we need to create a shard iterator, then using that, we can read the actual records from the shard:

```r
library(botor)
botor(region = 'eu-west-1')
shard_iterator <- kinesis_get_shard_iterator('crypto', '0')
records <- kinesis_get_records(shard_iterator$ShardIterator)
str(records)
```

Let's parse these records:

```r
records$Records[[1]]
records$Records[[1]]$Data

library(jsonlite)
fromJSON(as.character(records$Records[[1]]$Data))
```

### Parsing and structuring records read from the stream

Exercises:

* parse the loaded 25 records into a `data.table` object with proper column types. Get some help on the data format from the [Binance API docs](https://github.com/binance/binance-spot-api-docs/blob/master/web-socket-streams.md#trade-streams)!
* count the overall number of coins exchanged
* count the overall value of transactions in USD (hint: `binance_ticker_all_prices()` and `binance_coins_prices()`)
* visualize the distribution of symbol pairs

<details><summary>A potential solution that you should not look at before thinking ...</summary>

```shell
library(data.table)
dt <- rbindlist(lapply(records$Records, function(record) {
  fromJSON(as.character(record$Data))
}))

str(dt)
setnames(dt, 'a', 'seller_id')
setnames(dt, 'b', 'buyer_id')
setnames(dt, 'E', 'event_timestamp')
## Unix timestamp / Epoch (number of seconds since Jan 1, 1970): https://www.epochconverter.com
dt[, event_timestamp := as.POSIXct(event_timestamp / 1000, origin = '1970-01-01')]
setnames(dt, 'q', 'quantity')
setnames(dt, 'p', 'price')
setnames(dt, 's', 'symbol')
setnames(dt, 't', 'trade_id')
setnames(dt, 'T', 'trade_timestamp')
dt[, trade_timestamp := as.POSIXct(trade_timestamp / 1000, origin = '1970-01-01')]
str(dt)

for (id in grep('_id', names(dt), value = TRUE)) {
  dt[, (id) := as.character(get(id))]
}
str(dt)

for (v in c('quantity', 'price')) {
  dt[, (v) := as.numeric(get(v))]
}

library(binancer)
binance_coins_prices()

dt[, .N, by = symbol]
dt[symbol=='ETHUSDT']
dt[, from := substr(symbol, 1, 3)]
dt <- merge(dt, binance_coins_prices(), by.x = 'from', by.y = 'symbol', all.x = TRUE, all.y = FALSE)
dt[, value := as.numeric(quantity) * usd]
dt[, sum(value)]
```
</details>

### Actual stream processing instead of analyzing batch data

Let's write an R function to increment counters on the number of transactions per symbols:

1. Get sample raw data as per above (you might need to get a new shard iterator if expired):

   ```r
   records <- kinesis_get_records(shard_iterator$ShardIterator)$Record
   ```

2. Function to parse and process it

    ```r
    txprocessor <- function(record) {
      symbol <- fromJSON(as.character(record$Data))$s
      log_info(paste('Found 1 transaction on', symbol))
      redisIncr(paste('symbol', symbol, sep = ':'))
    }
    ```

3. Iterate on all records

    ```r
    library(logger)
    library(rredis)
    redisConnect()
    for (record in records) {
      txprocessor(record)
    }
    ```

4. Check counters

    ```r
    symbols <- redisMGet(redisKeys('symbol:*'))
    symbols

    symbols <- data.frame(
      symbol = sub('^symbol:', '', names(symbols)),
      N = as.numeric(symbols))
    symbols
    ```

5. Visualize

    ```r
    library(ggplot2)
    ggplot(symbols, aes(symbol, N)) + geom_bar(stat = 'identity')
    ```

6. Rerun step (1) and (3) to do the data processing, then (4) and (5) for the updated data visualization.

7. 🤦‍♂️

8. Let's make use of the next shard iterator:

    ```r
    ## reset counters
    redisDelete(redisKeys('symbol:*'))

    ## get the first shard iterator
    shard_iterator <- kinesis_get_shard_iterator('crypt', '0')$ShardIterator

    while (TRUE) {

      response <- kinesis_get_records(shard_iterator)

      ## get the next iterator
      shard_iterator <- response$NextShardIterator

      ## extract records
      records <- response$Record
      for (record in records) {
        txprocessor(record)
      }

      ## summarize
      symbols <- redisMGet(redisKeys('symbol:*'))
      symbols <- data.frame(
        symbol = sub('^symbol:', '', names(symbols)),
        N = as.numeric(symbols))

      ## visualize
      print(ggplot(symbols, aes(symbol, N)) + geom_bar(stat = 'identity') + ggtitle(sum(symbols$N)))
    }
    ```

### Stream processor daemon

0. So far, we used the `boto3` Python module from R via `botor` to interact with AWS, but this time we will integrate Java -- by calling the AWS Java SDK to interact with our Kinesis stream, then later on to run a Java daemon to manage our stream processing application.

    1. 💪 First, let's install Java and the `rJava` R package:

    ```shell
    sudo apt install r-cran-rjava
    ```

    2. 💪 Then the R package wrapping the AWS Java SDK and the Kinesis client, then update to the most recent dev version right away:

    ```shell
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('AWR.Kinesis', repos='https://cran.rstudio.com/'))"
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', devtools::install_github('daroczig/AWR.Kinesis', upgrade = FALSE))"
    ```

    3. 💪 Note, after installing Java, you might need to run `sudo R CMD javareconf` and/or restart R or the RStudio Server via `sudo rstudio-server restart` :/

    ```shell
    Error : .onLoad failed in loadNamespace() for 'rJava', details:
      call: dyn.load(file, DLLpath = DLLpath, ...)
      error: unable to load shared object '/usr/lib/R/site-library/rJava/libs/rJava.so':
      libjvm.so: cannot open shared object file: No such file or directory
    ```

    4. And after all, a couple lines of R code to get some data from the stream via the Java SDK (just like we did above with the Python backend):

    ```r
    library(rJava)
    library(AWR.Kinesis)
    records <- kinesis_get_records('crypto', 'eu-west-1')
    str(records)
    records[1]

    library(jsonlite)
    fromJSON(records[1])
    ```

1. Create a new folder for the Kinesis consumer files: `streamer`

2. Create an `app.properties` file within that subfolder

```
executableName = ./app.R
regionName = eu-west-1
streamName = crypto
applicationName = my_demo_app_sadsadsa
AWSCredentialsProvider = DefaultAWSCredentialsProviderChain
```

3. Create the `app.R` file:

```r
#!/usr/bin/Rscript
library(logger)
log_appender(appender_file('app.log'))
library(AWR.Kinesis)
library(methods)
library(jsonlite)

kinesis_consumer(

    initialize = function() {
        log_info('Hello')
        library(rredis)
        redisConnect(nodelay = FALSE)
        log_info('Connected to Redis')
    },

    processRecords = function(records) {
        log_info(paste('Received', nrow(records), 'records from Kinesis'))
        for (record in records$data) {
            symbol <- fromJSON(record)$s
            log_info(paste('Found 1 transaction on', symbol))
            redisIncr(paste('symbol', symbol, sep = ':'))
        }
    },

    updater = list(
        list(1/6, function() {
            log_info('Checking overall counters')
            symbols <- redisMGet(redisKeys('symbol:*'))
            log_info(paste(sum(as.numeric(symbols)), 'records processed so far'))
    })),

    shutdown = function()
        log_info('Bye'),

    checkpointing = 1,
    logfile = 'app.log')
```

4. 💪 Allow writing checkpointing data to DynamoDB and CloudWatch in IAM

5. Convert the above R script into an executable using the Terminal:

```shell
cd streamer
chmod +x app.R
```

6. Run the app in the Terminal:

```
/usr/bin/java -cp /usr/local/lib/R/site-library/AWR/java/*:/usr/local/lib/R/site-library/AWR.Kinesis/java/*:./ \
    com.amazonaws.services.kinesis.multilang.MultiLangDaemon \
    ./app.properties
```

7. Check on `app.log`

### Shiny app showing the progress

1. Reset counters

    ```r
    library(rredis)
    redisConnect()
    keys <- redisKeys('symbol*')
    redisDelete(keys)
    ```

2. 💪 Install the `treemap` package

    ```
    sudo apt install r-cran-httpuv r-cran-shiny r-cran-xtable r-cran-htmltools r-cran-igraph r-cran-lubridate r-cran-tidyr r-cran-quantmod r-cran-broom r-cran-zoo r-cran-htmlwidgets r-cran-tidyselect r-cran-rlist r-cran-rlang r-cran-xml
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages(c('treemap', 'highcharter'), repos='https://cran.rstudio.com/'))"
    ```

3. Run the below Shiny app

    ```r
    ## packages for plotting
    library(treemap)
    library(highcharter)

    ## connect to Redis
    library(rredis)
    redisConnect()

    library(shiny)
    library(data.table)
    ui     <- shinyUI(highchartOutput('treemap', height = '800px'))
    server <- shinyServer(function(input, output, session) {

        symbols <- reactive({

            ## auto-update every 2 seconds
            reactiveTimer(2000)()

            ## get frequencies
            symbols <- redisMGet(redisKeys('symbol:*'))
            symbols <- data.table(
                symbol = sub('^symbol:', '', names(symbols)),
                N = as.numeric(symbols))

            ## color top 3
            symbols[, color := 1]
            symbols[symbol %in% symbols[order(-N)][1:3, symbol], color := 2]

            ## return
            symbols

        })

        output$treemap <- renderHighchart({
            tm <- treemap(symbols(), index = c('symbol'),
                          vSize = 'N', vColor = 'color',
                          type = 'value', draw = FALSE)
            N <- sum(symbols()$N)
            hc_title(hctreemap(tm, animation = FALSE),
            text = sprintf('Transactions (N=%s)', N))
        })

    })
    shinyApp(ui = ui, server = server, options = list(port = 3838))
    ```

We will learn more about Shiny in the upcoming Data Visualization 4 class :)

### Dockerizing R scripts

Exercise: create a new GitHub repository with a `Dockerfile` installing `botor` (and its dependencies), `binancer` and `slackr` to be able to run the above jobs in a Docker container. Set up a DockerHub registry for the Docker image and start using in the Jenkins jobs.

Hints:

- create a new GitHub repo
- create a new RStudio project using the git repo
- set the default git user on the EC2 box

    ```shell
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    ```

- create a Personal Access Token set up on GitHub for HTTPS auth on your EC2 box
- example GitHub repo: https://github.com/daroczig/ceu-de3-docker-prep
- example DockerHub repo: https://hub.docker.com/r/daroczig/ceu-de3-week5-prep
- install Docker on EC2:

    ```shell
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce
    ```

- example run:

    ```shell
    docker run --rm -ti daroczig/ceu-de3-week5-prep R -e "binancer::binance_klines('BTCUSDT', interval = '1m', limit = 1)[1, close]"
    ```

## Home Assignment

The goal of this assignment is to confirm that the students have a general understanding on how to build data pipelines using Amazon Web Services and R, and can actually implement a stream processing application (either running in almost real-time or batched/scheduled way) in practice.

### Tech setup

To minimize the system administration and most of the engineering tasks for the students, the below pre-configured tools are provided as free options, but students can decide to build their own environment (on the top of or independently from these) and feel free to use any other tools:

* `crypto` stream in the Ireland region of the central CEU AWS account with the real-time order data from the Binance cryptocurrency exchange on Bitcoin (BTC), Ethereum (ETH), Litecoin (LTC), Neo (NEO), Binance Coin (BNB) and Tether (USDT) -- including the the attributes of each transaction as specified at https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md#trade-streams
* `de5-week2` Amazon Machine Image that you can use to spin up an EC2 node with RStudio Server, Shiny Server, Jenkins, Redis and Docker installed & pre-configured (use your AWS username and the password shared on Slack previously) along with the most often used R packages (including the ones we used for stream processing, eg `botor`, `AWR.Kinesis` and the `binancer` package)
* `de5-week2` EC2 IAM role with full access to Kinesis, Dynamodb, Cloudwatch and the `slack` token in the Parameter Store
* lecture and seminar notes at https://github.com/daroczig/CEU-R-prod

### Required output

Make sure to clean-up your EC2 nodes, security groups, keys etc created in the past weeks, as left-over AWS resources [will contribute negative points to your final grade](#preparations)!

* Minimal project (for grade up to "B"): schedule a Jenkins job that runs every hour and reads 250 messages from the `crypto` stream. Use this batch of data to

    * Draw a barplot on the overall number of units per symbol in the `#bots-final-project` Slack channel based on the number of transactions returned from the Kinesis stream
    * Get the current symbol prices from the Binance API, and compute the overall price of the 250 transactions in USD and print to the console in Jenkins

* Suggested project (for grade up to "A"): Create a stream processing application using the `AWR.Kinesis` R package's daemon + Redis (similar to what we did on the last week) to record the overall amount of coins exchanged on Binance (per symbol) in the most recent micro-batch (in other words, whatever records the Java daemon reports, sum up amount by symbol and store in Redis). No need to clear the cache ... so if a symbol was not included in a batch, don't update those keys in Redis. Create a Jenkins job that reads from this Redis cache and prints the overall value (in USD) of the transactions -- based on the coin prices reported by the Binance API at the time of request. Create at least two more additional charts that display a metric you find meaningful, and report in the "#bots-final-project" Slack channel.

### Delivery method

* Create a PDF document that describes your solution and all the main steps involved with low level details: attach screenshots (includeing the URL nav bar and the date/time widget of your OS, so like full-screen and not area-picked screenshots) of your browser showing what you are doing in RStudio Server or eg Jenkins, make sure that the code you wrote is either visible on the screenshots, or included in the PDF. The minimal amount of screenshots are: EC2 creation, R code shown in your RStudio Server, Jenkins job config page, Jenkins job output, Slack channel notifications.
* STOP the EC2 Instance you worked on, but don’t terminate it, so we can start it and check how it works. Note that your instance will be terminated by us after the end of the class.
* Include the `instance_id` on the first page of the PDF, along with your name or student id.
* Upload the PDF to Moodle.

### Submission deadline

Midnight (CET) on April 28, 2021

### Getting help

Contact Gergely Daroczi and Mihaly Orsos on the `ceu-bizanalytics` Slack channel.


## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-prod/issues).
