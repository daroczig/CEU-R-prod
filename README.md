Here you can find the materials for the "[Data Engineering 4: Using R in Production](https://courses.ceu.edu/courses/2019-2020/data-engineering-4-using-r-production)" course, part of the [MSc in Business Analytics](https://economics.ceu.edu/program/master-science-business-analytics) at CEU.

Table of Contents
=================

* [Table of Contents](#table-of-contents)
   * [Schedule](#schedule)
   * [Home assignment](#home-assignment)
   * [Week 1: Using R in the Cloud](#week-1-using-r-in-the-cloud)
      * [Background: Example use-cases and why to use R in the cloud?](#background-example-use-cases-and-why-to-use-r-in-the-cloud)
      * [Welcome to AWS!](#welcome-to-aws)
      * [Getting access to EC2 boxes](#getting-access-to-ec2-boxes)
      * [Create and connect to an EC2 box](#create-and-connect-to-an-ec2-box)
      * [Install RStudio Server on EC2](#install-rstudio-server-on-ec2)
      * [Connect to the RStudio Server](#connect-to-the-rstudio-server)
      * [Play with R for a bit](#play-with-r-for-a-bit)
      * [Prepare to schedule R commands](#prepare-to-schedule-r-commands)
      * [Schedule R commands](#schedule-r-commands)
      * [Homework](#homework)
   * [Week 2: Scaling R applications](#week-2-scaling-r-applications)
      * [Recap](#recap)
      * [Preparations](#preparations)
      * [Set up an easy to remember IP address](#-set-up-an-easy-to-remember-ip-address)
      * [Set up an easy to remember domain name](#-set-up-an-easy-to-remember-domain-name)
      * [ScheduleR improvements](#-scheduler-improvements)
      * [Schedule R scripts](#schedule-r-scripts)
      * [Intro to redis](#intro-to-redis)
      * [Interacting with Slack](#interacting-with-slack)
         * [Using Slack from Jenkins](#using-slack-from-jenkins)
         * [Note on storing the Slack token](#note-on-storing-the-slack-token)
         * [Using Slack from R](#using-slack-from-r)
      * [Better handling of secrets and credentials](#better-handling-of-secrets-and-credentials)
      * [Job Scheduler exercises](#job-scheduler-exercises)
  * [Week 3: Stream processing with R](#week-3-stream-processing-with-r)
  * [Contact](#contact)

## Schedule

* 15:30 - 17:10 Session 1
* 17:10 - 17:30 Coffee break
* 17:30 - 19:10 Session 2

## Home Assignment

The goal of this assignment is to confirm that the students have a general understanding on how to build data pipelines using Amazon Web Services and R, and can actually implement a stream processing application (either running in almost real-time or batched/scheduled way) in practice.

Details to be shared later.

## Week 1: Using R in the Cloud

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

3. ~~Convert the generated pem key to PuTTY format~~Non need to do this anymore, AWS can provide the key as PPK now.

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
    3. Pick the `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type` AMI
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
    wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5033-amd64.deb
    sudo gdebi rstudio-server-1.2.5033-amd64.deb
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
        Classes ‘data.table’ and 'data.frame':	180 obs. of  12 variables:
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

### Homework

Read the [rOpenSci Docker tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) -- quiz next week! Think about why we might want to use Docker.

## Week 2: Scaling R applications

> Hello folks, we'll start at 15:30.

### Intro to the online version of this class

* I highly recommended to get a second screen for your laptop: it can be a monitor attached to your laptop, or the TV in your living room connected via HDMI cable to your laptop, or if you have a spare tablet or laptop that you can use -- all should work fine. The goal is to have a dedicated screen for the video-conferencing, so that you can follow the stream (and ask questions), and have your usual laptop screen to do the exercises etc
* It's much better to use a headphone (compared to using the laptop speakers and microphone) so that you hear better all the others and also the others can better understand you
* Please click on the "mute" button on your end when not asking questions to reduce background noise
* Please DO feel free to ask questions and interact with the course at any time -- doing the class remotely doesn't mean you are just watching a video! Please raise your voice if something is not clear, and follow the exercises to make the most out of this unfortunate situation.

Quick intro to Google Hangouts / Meet:

* mute/unmute
* enable/disable camera (save bandwith and CPU cycles)
* share your screen or a window
* chat sidebar
* alternative way of reaching me: email, slack, moodle

### Recap

What we convered last week:

1. 2FA/MFA in AWS
2. Creating EC2 nodes
3. Connecting to EC2 nodes via SSH/Putty (note the difference between the PPK and PEM key formats)
4. Updating security groups
5. Installing RStudio Server
6. The difference between R Console and Shell
7. Adding new Linux users
8. Granting `sudo` access to Linux users
9. Installing R packages system-wide VS in the user's home folder
10. Installing and setting up Jenkins
11. Debugging issues, eg small instance with limited memory for compiling packages from source and user permissions

Note the above detailed steps for the above!

Also, in the below steps, you can skip running all the instructions prefixed with 💪 -- as the Amazon AMI has already configured so for your convenience, and these steps are just here as an FYI if you want to reproduce the same environment later (eg for a hobby project or work).


### Quiz

Please fill in the form at https://goo.gl/forms/oKQ0zILuQljgBxyH3

### Preparations

1. Log in to the central CEU AWS account: https://ceu.signin.aws.amazon.com/console
2. Did you use 2FA / MFA?!
3. Use the Ireland regiuon
4. Go to the EC2 console at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
5. Realize the mess we left there from last week! 😱 Fix it. Kill your old security groups as well. Remove unneded keys.
6. 💪 Check on the wasted money in the AWS Cost Explorer
7. Create a new `t3.micro` instance using the `de4-week2` AMI and `t3.small` instance size using a new security group with a unique name and opening up the 22 (ssh), 8000 (alternate ssh), 8787 (rstudio) and 8080 (jenkins) ports
8. Log in to RStudio using the new instance's public IP address and 8787 port, then the `ceu` username and `ceudata` password
9. Check if the price of a Bitcoin is more than $4,000 (feel free to scroll up to get some hints from last week's R scripts)

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

    - fill in the desired `Name` (subdomain)
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create`

4. Now you will be able to access your box using this custon (sub)domain, no need to remember IP addresses.

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
Rscript /home/ceu/de4.R
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
store <- function(symbol) {
  print(paste('Looking up and storing', symbol))
  redisSet(paste('price', symbol, sep = ':'), 
           binance_klines(paste0(symbol, 'USDT'), interval = '1m', limit = 1)$close)
}

store('BTC')
store('ETH')

## list all keys with the "price" prefix and lookup the actual values
redisMGet(redisKeys('price:*'))
```
</details>

More on databases at the "Mastering R" class in the Spring semester ;)

### Interacting with Slack

1. Join the #ba-de4-2019-bots channel in the `ceu-bizanalytics` Slack
2. 💪 A custom Slack app is already created at https://api.slack.com/apps/A9FBHCLPR, but feel free to create a new one and use the related app in the following steps
3. Look up the app's bots in the sidebar
4. Look up the Access Token

#### Using Slack from Jenkins

1. Get familiar with the Slack Notifier Jenkins plugin: https://plugins.jenkins.io/slack
2. Configure global Slack options (what about storing the token?)
3. Set up post-hook actions to alert in Slack if a Jenkins job is failing

#### Talk: Productionizing R in the Cloud

Slides at http://bit.ly/satrday-la-2018-daroczig

#### Note on storing the Slack token

1. Do not store the token in plain-text!
2. Let's use Amazon's Key Management Service: https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (slides 73-75)
3. 💪 Instead of using the Java SDK, let's install `boto3` Python module and use via `reticulate`:

    ```shell
    sudo apt install python4-pip
    sudo pip3 install boto3
    sudo Rscript -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('reticulate', repos='https://cran.rstudio.com/'))"
    sudo Rscript -e "library(devtools);withr::with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/botor', upgrade_dependencies = FALSE))"
    ```

4. 💪 Create a KMS key in IAM: `alias/de4`
5. Grant access to that KMS key by creating an EC2 IAM role at https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles with the `AWSKeyManagementServicePowerUser` policy and explicit grant access to the key in the KMS console
6. Attach the newly created IAM role
7. Use this KMS key to encrypt the Slack token:

    ```r
    library(botor)
    botor(region = 'eu-west-1')
    kms_encrypt('token', key = 'alias/de4')
    ```

8. Store the ciphertext and use `kms_decrypt` to decrypt later, see eg 

    ```r
    kms_decrypt("AQICAHhh7Ku/BWdSbCqos9k49Vnk1+WytvoesgX+1bOvLAlyegHa210D93pgytNnThR9qVVxAAAAmjCBlwYJKoZIhvcNAQcGoIGJMIGGAgEAMIGABgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKkH9le72xKmMsgjTQIBEIBT/7MbIV2sG6Hh+fb8BJQ9a6VNOZ1rhPAgvSET6IUdiki92fMZ6dDBOpmSSuaa3t8KIF9KtrlbQAYQNtPVHUvFl1GpyM0k8bD7jLSsUPeRjFNoI+Q=")
    ```

#### Using Slack from R

4. 💪 Install the Slack R client

    ```shell
    sudo apt install r-cran-rlang r-cran-purrr r-cran-tibble r-cran-dplyr
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('slackr', repos='https://cran.rstudio.com/'))"
    ```

5. Init and send our first messages with `slackr`

    ```r
    library(botor)
    token <- kms_decrypt("AQICAHhh7Ku/BWdSbCqos9k49Vnk1+WytvoesgX+1bOvLAlyegHa210D93pgytNnThR9qVVxAAAAmjCBlwYJKoZIhvcNAQcGoIGJMIGGAgEAMIGABgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKkH9le72xKmMsgjTQIBEIBT/7MbIV2sG6Hh+fb8BJQ9a6VNOZ1rhPAgvSET6IUdiki92fMZ6dDBOpmSSuaa3t8KIF9KtrlbQAYQNtPVHUvFl1GpyM0k8bD7jLSsUPeRjFNoI+Q=")
    library(slackr)
    slackr_setup(username = 'jenkins', api_token = token, icon_emoji = ':jenkins-rage:')
    text_slackr(text = 'Hi there!', channel = '#ba-de4-2019-bots')
    ```

6. A more complex message

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    msg <- sprintf(':money_with_wings: The current Bitcoin price is: $%s', prices[symbol == 'BTC', usd])
    text_slackr(text = msg, preformatted = FALSE, channel = '#ba-de4-2019-bots')
    ```

7. Or plot

    ```r
    library(ggplot2)
    klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
    p <- ggplot(klines, aes(close_time, close)) + geom_line()
    ggslackr(plot = p, channels = '#ba-de4-2019-bots', width = 12)
    ```

### Better handling of secrets and credentials

Besides KMS, there are a few other great options as well, see eg the System Manager's Parameter Store at https://eu-west-1.console.aws.amazon.com/systems-manager/parameters/?region=eu-west-1 (which will need you to grant access to SSM for the related IAM role, eg via attaching the `AmazonSSMReadOnlyAccess` policy):

```r
ssm_get_parameter('slack')
```

We will also cover this in more details in the Mastering R class in the Spring semester.

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
  slackr_setup(username = 'jenkins', api_token = token, icon_emoji = ':jenkins-rage:')
  text_slackr(
    text = paste('uh ... oh... BTC price:', btc), 
    channel = '#ba-de4-2019-bots')
}
```
</details>

## Week 3: Stream processing with R

### Quiz

Instead of doing a quiz this week ... you get all the 10% for rather providing some (anonymous) [feedback](#feedback) on this course at the end of the class today.
## Feedback

We are continuously trying to improve the content of this class and looking forward to any feedback and suggestions: https://forms.gle/C5YDtJNxj7kTHjxU9

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-prod/issues).
