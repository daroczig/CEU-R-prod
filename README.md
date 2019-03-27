Here you can find the materials for the second part (3rd, 4th and 5th week) of the "[Data Infrastructure in Production](https://economics.ceu.edu/courses/data-infrastructure-production-full-time)" course, part of the [MSc in Business Analytics](https://economics.ceu.edu/program/master-science-business-analytics) at CEU.

Table of Contents
=================

* [Table of Contents](#table-of-contents)
   * [Schedule](#schedule)
   * [Home assignment](#home-assignment)
      * [Tech setup](#tech-setup)
      * [Required output](#required-output)
      * [Delivery method](#delivery-method)
      * [Submission deadline](#submission-deadline)
      * [Getting help](#getting-help)
   * [Week 1: Intro - Infrastructure Applications](#week-1-intro---infrastructure-applications)
   * [Week 2: Streaming](#week-2-streaming)
   * [Week 3: Lambda Architecture and Serverless Computing](#week-3-lambda-architecture-and-serverless-computing)
   * [Week 4: Using R in the Cloud](#week-4-using-r-in-the-cloud)
      * [Background: Example use-cases and why to use R in the cloud?](#background-example-use-cases-and-why-to-use-r-in-the-cloud)
      * [Welcome to AWS!](#welcome-to-aws)
      * [Getting access to EC2 boxes](#getting-access-to-ec2-boxes)
      * [Create and connect to an EC2 box](#create-and-connect-to-an-ec2-box)
      * [Install RStudio Server on EC2](#install-rstudio-server-on-ec2)
      * [Connect to the RStudio Server](#connect-to-the-rstudio-server)
      * [Set up an easy to remember domain name](#set-up-an-easy-to-remember-domain-name)
      * [Play with R for a bit](#play-with-r-for-a-bit)
      * [Prepare to schedule R commands](#prepare-to-schedule-r-commands)
      * [Homework](#homework)
   * [Week 5: Scaling R applications](#week-5-scaling-r-applications)
      * [Start your cloud instance](#start-your-cloud-instance)
      * [Schedule R commands](#schedule-r-commands)
      * [Schedule R scripts](#schedule-r-scripts)
      * [ScheduleR improvements](#scheduler-improvements)
      * [Intro to redis](#intro-to-redis)
      * [Interacting with Slack](#interacting-with-slack)
         * [Using Slack from Jenkins](#using-slack-from-jenkins)
         * [Note on storing the Slack token](#note-on-storing-the-slack-token)
         * [Using Slack from R](#using-slack-from-r)
      * [Job Scheduler exercises](#job-scheduler-exercises)
   * [Week 6: Stream processing with R](#week-6-stream-processing-with-r)
   * [Feedback](#feedback)

## Schedule

* 13:30 - 15:10 Session 1
* 15:10 - 15:30 Coffee break
* 15:30 - 17:10 Session 2

## Home assignment

The goal of this assignment is to confirm that the students have a general understanding on how to build data pipelines using Amazon Web Services and R or Databricks, and can actually implement a stream processing application (either running in almost real-time or batched/scheduled way) in practice.

### Tech setup

To minimize the system administration and most of the engineering tasks for the students, the below pre-configured tools are provided as free options, but students can decide to build their own environment (on the top of or independently from these) and feel free to use any other tools:

* "binance" stream in the Ireland region of the central CEU AWS account with the real-time order data from the Binance cryptocurrency exchange on Bitcoin (BTC), Ethereum (ETH), Litecoin (LTC), Neo (NEO), Binance Coin (BNB) and Tether (USDT) -- including the the attributes of each transaction as specified at https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md#trade-streams
* "data-infra-in-prod-R-image-v2" Amazon Machine Image that you can use to spin up an EC2 node with RStudio Server, Shiny Server, Jenkins, Redis and Docker installed & pre-configured (use the “ceu” username and “data” or “ceudata” password if asked for all services) along with the most often used R packages (including the ones we used for stream processing, eg `AWR.Kinesis` and the `binancer` package)
* "all-the-r-things" security group with the ports already opened for RStudio Server, Shiny Server, Jenkins and Redis as well
* "all-the-aws-things" EC2 IAM role with full access to Kinesis, Dynamodb, Cloudwatch and encrypt/decrypt access to the "all-the-keys" KMS key
* "all-the-keys" KMS key that you can use to decrypt the below string to get a Slack access token for the "ceu-data-bot" user: TODO
* lecture and seminar notes at https://github.com/daroczig/CEU-R-prod

### Required output

* Minimal project (for grade up to "B"): schedule a Jenkins job that runs every hour and reads 250 messages from the "binance" stream. Use this sample to

    * Draw a barplot on the overall number of units per symbol in the "#bots-final-project" Slack channel based on the number of transactions returned from the Kinesis stream
    * Get the current symbol prices from the Binance API, and compute the overall price of the 250 transactions in USD and print to the console
    
* Suggested project (for grade up to "A"): Create a stream processing application using the `AWR.Kinesis` R package + Redis. Create a dashboard output showing the overall prices in USD as reported by the Binance API at the time of request, broken down by the symbol pairs (e.g. a treemap). Create at least two more additional chart that displays a metric you find meaningful.

### Delivery method

* Document and explain your solution along the code you wrote in a PDF document. Include screenshots of your browser showing what you are doing in RStudio Server or eg Jenkins -- including the URL nav bar.
* STOP the EC2 Instance you worked on, but don’t terminate it, so we can start it and check how it works. 
* Please send us the PDF and the instance id of your EC2 instance when you are finished to ceu-data@googlegroups.com. Please include your student ID both in the PDF and the email.

### Submission deadline

Midnight (CET) on April 30, 2019

### Getting help

Contact Cagdas Yetkin (TA) on the `ceu-bizanalytics` Slack or at YetkinC@ceu.edu

## Week 1: Intro - Infrastructure Applications

By Zoltan Toth: https://ceulearning.ceu.edu/course/view.php?id=9300&section=1


## Week 2: Streaming

By Zoltan Toth: https://ceulearning.ceu.edu/course/view.php?id=9300&section=2

## Week 3: Lambda Architecture and Serverless Computing

By Zoltan Toth: https://ceulearning.ceu.edu/course/view.php?id=9300&section=3

## Week 4: Using R in the Cloud

**Goal**: learn how to run and schedule R jobs in the cloud.

### Background: Example use-cases and why to use R in the cloud? 

http://bit.ly/budapestdata-2018-dbs-in-a-startup (presented at the [Budapest Data Forum in 2018](https://budapestdata.hu/2018/hu/))

### Welcome to AWS!

1. Use the central CEU AWS account: https://ceu.signin.aws.amazon.com/console
2. Set up 2FA (go to IAM / Users / username / Security credentials / Assigned MFA device): https://console.aws.amazon.com/iam
3. Secure your access keys:

    > "When I woke up the next morning, I had four emails and a missed phone call from Amazon AWS - something about 140 servers running on my AWS account, mining Bitcoin"
    -- [Hoffman said](https://www.theregister.co.uk/2015/01/06/dev_blunder_shows_github_crawling_with_keyslurping_bots)
    
    > "Nevertheless, now I know that Bitcoin can be mined with SQL, which is priceless ;-)"
    -- [Uri Shaked](https://medium.com/@urish/thank-you-google-how-to-mine-bitcoin-on-googles-bigquery-1c8e17b04e62)

    PS probably you do not really need to store any access keys, but you may rely on roles and KMS

4. Let's use the `eu-west-1` Ireland region

### Getting access to EC2 boxes

**Note**: we follow the instructions on Windows in the Computer Lab, but please find below how to access the boxes from Mac or Linux as well when working with the instances remotely.

1. Create (or import) an SSH key in AWS (EC2 / Key Pairs): https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName
2. Get an SSH client:

    * Windows -- Download and install PuTTY: https://www.putty.org
    * Mac -- Install PuTTY for Mac using homebrew or macports

            sudo brew install putty
            sudo port install putty

    * Linux -- probably the OpenSSH client is already installed, but to use the same tools on all operating systems, please install and use PuTTY on Linux too, eg on Ubuntu:

            sudo apt install putty

3. Convert the generated pem key to PuTTY format

    * GUI: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html#putty-private-key
    * CLI:

            puttygen key.pem -O private -o key.ppk

4. Make sure the key is readable only by your Windows/Linux/Mac user, eg

        chmod 0400 key.ppk

### Create and connect to an EC2 box

1. Create a tiny EC2 instance

    0. Optional: create an Elastic IP for your box
    1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
    2. Click "Launch Instance"
    3. Pick the `Ubuntu Server 18.04 LTS (HVM), SSD Volume Type` AMI
    4. Pick `t2.micro` instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
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

### Install RStudio Server on EC2

1. Look at the docs: https://www.rstudio.com/products/rstudio/download-server
2. Download Ubuntu `apt` package list

        sudo apt update

3. Install dependencies

        sudo apt install r-base gdebi-core

4. Try R

        R

5. Install RStudio Server

        wget https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb
        sudo gdebi rstudio-server-1.1.463-amd64.deb

6. Check process and open ports

        rstudio-server status
        sudo rstudio-server status
        sudo ps aux| grep rstudio
        sudo systemctl status rstudio-server
        sudo netstat -tapen | grep LIST
        sudo netstat -tapen

7. Look at the docs: http://docs.rstudio.com/ide/server-pro/

### Connect to the RStudio Server

1. Confirm that the service is up and running and the port is open

        ubuntu@ip-172-31-12-150:~$ sudo netstat -tapen | grep LIST
        tcp        0      0 0.0.0.0:8787            0.0.0.0:*               LISTEN      0          49065       23587/rserver
        tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          15671       1305/sshd
        tcp6       0      0 :::22                   :::*                    LISTEN      0          15673       1305/sshd

2. Try to connect to the host from a browser on port 8787, eg http://foobar.eu-west-1.compute.amazonaws.com:8787
3. Realize it's not working
4. Open up port 8787 in the security group

    ![](https://d2908q01vomqb2.cloudfront.net/b6692ea5df920cad691c20319a6fffd7a4a766b8/2017/10/12/r-update-1.gif)

5. Authentication: http://docs.rstudio.com/ide/server-pro/authenticating-users.html
6. Create a new user:

        sudo adduser ceu

7. Login & quick demo:

        1+2
        plot(mtcars)
        install.packages('fortunes')
        library(fortunes)
        fortune()
        fortune(200)
        system('whoami')

8. Reload webpage (F5), realize we continue where we left the browser :)
9. Demo the terminal:

        $ sudo whoami
        ceu is not in the sudoers file.  This incident will be reported.

8. Grant sudo access to the new user by going back to SSH with `root` access:

        sudo apt install -y mc
        sudo mc
        sudo mcedit /etc/sudoers
        sudo adduser ceu admin
        man adduser
        man deluser

Note 1: might need to relogin / restart RStudio / reload R / reload page
Note 2: you might want to add `NOPASSWD` to the `sudoers` file:

        ceu ALL=(ALL) NOPASSWD:ALL

Although also note (3) the related security risks.

9. Custom login page: http://docs.rstudio.com/ide/server-pro/authenticating-users.html#customizing-the-sign-in-page
10. Custom port: http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

### Set up an easy to remember domain name

1. Go to Route 53: https://console.aws.amazon.com/route53/home
2. Go to Hosted Zones and click on `ceudata.net`
3. Create a new Record, where

    - fill in the desired `Name` (subdomain)
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create`

### Play with R for a bit

1. Installing packages:

        ## don't do this at this point!
        ## install.packages('ggplot2')

2. Use binary packages instead via apt & Launchpad PPA:

        sudo add-apt-repository ppa:marutter/rrutter

        sudo add-apt-repository ppa:marutter/c2d4u
        
        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install r-cran-ggplot2

3. Ready to use it from R after restarting the session:

        library(ggplot2)
        ggplot(mtcars, aes(hp)) + geom_histogram()

4. Get some real-time data and visualize it:

    1. Install devtools in the RStudio/Terminal:

            sudo apt-get install r-cran-devtools r-cran-data.table r-cran-httr r-cran-futile.logger r-cran-jsonlite r-cran-data.table r-cran-stringi r-cran-stringr r-cran-glue

    2. Install an R package from GitHub to interact with crypto exchanges:

            install.packages('snakecase')
            devtools::install_github('daroczig/binancer', upgrade_dependencies = FALSE)

    3. First steps with live data:

            library(binancer)
            klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
            str(klines)
            summary(klines$close)

    4. Visualize the data

            library(ggplot2)
            ggplot(klines, aes(close_time, close)) + geom_line()

    5. Create a candle chart

            library(scales)
            ggplot(klines, aes(open_time)) +
                geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
                geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
                theme_bw() + theme('legend.position' = 'none') + xlab('') +
                ggtitle(paste('Last Updated:', Sys.time())) +
                scale_y_continuous(labels = dollar) +
                scale_color_manual(values = c('#1a9850', '#d73027')) # RdYlGn

    6. Compare prices of 4 currencies in the past 24 hours on 15 mins intervals:

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

        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
        echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list
        sudo apt update
        sudo apt install openjdk-8-jdk-headless jenkins ## installing Java as well
        sudo netstat -tapen | grep java

2. Open up port 8080 in the related security group
3. Access Jenkins from your browser and finish installation

    1. Read the initial admin password from RStudio/Terminal via

            sudo cat /var/lib/jenkins/secrets/initialAdminPassword

    2. Proceed with installing the suggested plugins
    3. Create your first user (eg `ceu`)

### Homework

Read the [rOpenSci Docker tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) -- quiz next week!

## Week 5: Scaling R applications

Quiz: https://goo.gl/forms/oKQ0zILuQljgBxyH3

### Start your cloud instance

1. Go to the AWS EC2 console. Don't forget to use the Ireland region: https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
2. Create a new EC2 instance using the `de3-week5` AMI and `t2.small` instance size using a new security group with a unique name and opening up the 8787 and 8080 ports
3. Log in to RStudio using the new instance's public IP address and 8787 port, then the `ceu` username and `ceudata` password
4. Check if the price of a Bitcoin is more than $4,000 (feel free to scroll up to get some hints from last week's R scripts)

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

            R -e "library(binancer);binance_coins_prices()[symbol == 'BTC', usd]"

    6. Run the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2018-2019/images/jenkins-errors.png)

4. Debug & figure out what's the problem ...
5. Install R packages system wide from RStudio/Terminal (more on this later):

        sudo Rscript -e "library(devtools);with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/binancer', upgrade_dependencies = FALSE))"

6. Rerun the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2018-2019/images/jenkins-success.png)

### Schedule R scripts

1. Create an R script with the below content and save on the server, eg as `/home/ceu/bitcoin-price.R`:

        library(binancer)
        prices <- binance_coins_prices()
        library(futile.logger)
        flog.info('The current Bitcoin price is: %s', prices[symbol == 'BTC', usd])
        
2. Instead of calling `R -e "..."` in the Jenkins jobs, reference the above R script using `Rscript` instead

### ScheduleR improvements

1. Learn about little R: https://github.com/eddelbuettel/littler
2. Set up e-mail notifications via SNS: https://eu-west-1.console.aws.amazon.com/ses/home?region=eu-west-1#

    1. Whitelist and confirm your e-mail address at https://eu-west-1.console.aws.amazon.com/ses/home?region=eu-west-1#verified-senders-email:
    2. Take a note on the SMTP settings:

        * Server: email-smtp.eu-west-1.amazonaws.com
        * Port: 587
        * TLS: Yes

    3. Create SMTP credentials and note the username and password
    4. Configure Jenkins at http://SERVERNAME.ceudata.net:8080/configure

        1. Set up the default FROM e-mail address: jenkins@ceudata.net
        2. Search for "Extended E-mail Notification" and configure

           * SMTP Server
           * Click "Advanced"
           * Check "Use SMTP Authentication"
           * Enter User Name from the above steps from SNS
           * Enter Password from the above steps from SNS
           * Check "Use SSL"
           * SMTP port: 587

    5. Set up "Post-build Actions" in Jenkins: Editable Email Notification - read the manual and info popups, configure to get an e-mail on job failures and fixes

3. Look at other Jenkins plugins, eg the Slack Notifier: https://plugins.jenkins.io/slack

### Intro to redis

We need a persistent storage for our Jenkins jobs ... let's give a try to a key-value database:

1. Install server

   ```
   sudo apt install redis-server
   netstat -tapen | grep LIST
   ```

2. Install client

    ```
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('rredis', repos='https://cran.rstudio.com/'))"
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

4. Exercises

    - Create a Jenkins job running every minute to cache the most recent Bitcoin and Ethereum prices in Redis
    - Write an R script in RStudio that can read the Bitcoin and Ethereum prices from the Redis cache

Example solution:

```r
library(rredis)
redisConnect()

redisSet('price:BTC', binance_klines('BTCUSDT', interval = '1m', limit = 1)$close)
redisSet('price:ETH', binance_klines('ETHUSDT', interval = '1m', limit = 1)$close)

redisGet('price:BTC')
redisGet('price:ETH')

redisMGet(c('price:BTC', 'price:ETH'))
```

Example solution using a helper function doing some logging:

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

### Interacting with Slack

1. Join the #ba-de3-2018-bots channel
2. A custom Slack app is already created at https://api.slack.com/apps/A9FBHCLPR, but feel free to create a new one and use the related app in the following steps
3. Look up the app's bots in the sidebar
4. Look up the Access Token

#### Using Slack from Jenkins

1. Get familiar with the Slack Notifier Jenkins plugin: https://plugins.jenkins.io/slack
2. Configure global Slack options (what about storing the token?)
3. Set up post-hook actions to alert in Slack if a Jenkins job is failing

#### Note on storing the Slack token

1. Do not store the token in plain-text!
2. Let's use Amazon's Key Management Service: https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (slides 73-75)
3. Instead of using the Java SDK, let's install `boto3` Python module and use via `reticulate`:

    ```shell
    sudo apt install python-pip
    sudo pip install boto3
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('reticulate', repos='https://cran.rstudio.com/'))"
    sudo Rscript -e "library(devtools);withr::with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/botor', upgrade_dependencies = FALSE))"
    ```

4. Create a KMS key in IAM: `alias/all-the-keys`
5. Grant access to that KMS key by using an IAM role: https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles with the `AWSKeyManagementServicePowerUser` policy and explicit grant access to the key
6. Attach the newly created IAM role
7. Use this KMS key to encrypt the Slack token:

    ```r
    library(botor)
    botor(region = 'us-east-1')
    kms_encrypt('token', key = 'alias/all-the-keys')
    ```

8. Store the ciphertext and use `kms_decrypt` to decrypt later, see eg 

    ```r
    kms_decrypt("AQICAHgTG+lvWpBOjwX4kAP2TTx+kP07ZEllSpqh7pvh9N6L6wHIA1zHbFByziZDVyfcL4hiAAAAZjBkBgkqhkiG9w0BBwagVzBVAgEAMFAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMzoyflIia43kBbeSQAgEQgCP1oJhVadkkhhkkDYT1VpPDW/O/xdcoj+luBnZIs4O/adBgAQ==")
    ```

#### Using Slack from R

4. Install the Slack R client

    ```
    sudo apt install r-cran-rlang r-cran-purrr r-cran-tibble r-cran-dplyr
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('slackr', repos='https://cran.rstudio.com/'))"
    ```

5. Init and send our first messages with `slackr`

    ```r
    library(botor)
    token <- kms_decrypt('AQICAHgTG+lvWpBOjwX4kAP2TTx+kP07ZEllSpqh7pvh9N6L6wEcOn1eIIcW1lX57oKF0GfCAAAAiTCBhgYJKoZIhvcNAQcGoHkwdwIBADByBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGvtEjjWZmpfVBigHQIBEIBFHD8IJ0BKUwb+1A5nJLZSpKam/ESW2t4BYX4x1u8rv2ODoRbzPNHmeoo2gYkZ4wTJY6vtkdPUdr1ZUeJnWFnIkPNW8+6m')
    library(slackr)
    slackr_setup(username = 'ceudatabot', api_token = token, icon_emoji = ':r:')
    text_slackr(text = 'Hi there!', channel = '#ba-de3-2018-bots)
    ```

6. A more complex message

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    msg <- sprintf(':money_with_wings: The current Bitcoin price is: $%s', prices[symbol == 'BTC', usd])
    text_slackr(text = msg, preformatted = FALSE, channel = '#ba-de3-2018-bots')
    ```

7. Or plot

    ```r
    library(ggplot2)
    klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
    p <- ggplot(klines, aes(close_time, close)) + geom_line()
    ggslackr(plot = p, channels = '#ba-de3-2018-bots', width = 12)
    ```

### Job Scheduler exercises

* Create a Jenkins job to alert if Bitcoin price is below $3.8K or higher than $4K
* Create a Jenkins job to alert if Bitcoin price changed more than $200 in the past hour
* Create a Jenkins job to alert if Bitcoin price changed more than 5% in the past day
* Create a Jenkins job running hourly to generate a candlestick chart on the price of BTC and ETH

Example solution for (1):

```r
## get data right from the Binance API
library(binancer)
btc <- binance_klines('BTCUSDT', interval = '1m', limit = 1)$close

## or from the local cache (updated every minute from Jenkins as per above)
library(rredis)
btc <- redisGet('price:BTC')

## send alert
if (btc < 3800 | btc > 4000) {
  library(botor)
  token <- kms_decrypt('AQICAHgTG+lvWpBOjwX4kAP2TTx+kP07ZEllSpqh7pvh9N6L6wEcOn1eIIcW1lX57oKF0GfCAAAAiTCBhgYJKoZIhvcNAQcGoHkwdwIBADByBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDGvtEjjWZmpfVBigHQIBEIBFHD8IJ0BKUwb+1A5nJLZSpKam/ESW2t4BYX4x1u8rv2ODoRbzPNHmeoo2gYkZ4wTJY6vtkdPUdr1ZUeJnWFnIkPNW8+6m')
  library(slackr)
  slackr_setup(username = 'ceudatabot', api_token = token, icon_emoji = ':r:')
  text_slackr(
    text = paste('uh ... oh... BTC price:', btc), 
    channel = '#ba-de3-2018-bots')
}
```

## Week 6: Stream processing with R

### Background: Example use-case and why to use R to do stream processing? 

https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (presented at the Big Data Day Los Angeles 2016, EARL 2016 London and useR! 2017 Brussels)

### Setting up a demo stream

This section describes how to set up a Kinesis stream with 5 shards on the live Binance transactions read from its websocket -- running in a Docker container, then feeding the JSON lines to Kinesis via the Amazon Kinesis Agent.

**Please note that you don't have to do all these steps on your computer, it's enough if I do all these once for the class.**

1. Start a `t2.micro` instance running Amazon Linux (easier to install the Kinesis Agent) with a known key. Make sure to set a name and enable termination protection!

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
    sudo yum install –y https://s3.amazonaws.com/streaming-data-agent/aws-kinesis-agent-latest.amzn1.noarch.rpm
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

9. Attach an IAM role that can write to Kinesis and Cloudwatch, eg the `kinesis-admin` in the CEU account, then restart the agent

    ```
    sudo service aws-kinesis-agent restart
    ```

10. Check the AWS console's monitor if all looks good there as well: https://eu-west-1.console.aws.amazon.com/kinesis/home?region=eu-west-1#/streams/details?streamName=crypto&tab=monitoring

### A simple stream consumer app in R

**From now on, please do all the below steps on your computer -- everyone back to work!**

Start a `t2.small` instance using the `de3-week6` AMI -- running RStudio Server, Jenkins and a couple of extra packages and tools pre-installed from last week. Let's use the same `kinesis-admin` IAM role so that we can easily read from the stream.

Last week we used the `boto3` Python module from R, this week we will integrate Java -- by calling the AWS Java SDK to interact with our Kinesis stream, then later on to run a Java daemon to manage our stream processing application.

First, let's install Java and the `rJava` R package:

```
sudo apt install r-cran-rjava
```

Then the R package wrapping the AWS Java SDK and the Kinesis client, then update to the most recent dev version right away:

```
sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('AWR.Kinesis', repos='https://cran.rstudio.com/'))"
sudo R -e "library(devtools);with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/AWR.Kinesis'))"
```

Note, after installing Java, you might need to run `sudo R CMD javareconf` and/or restart R or the RStudio Server via `sudo rstudio-server restart` :/

```
Error : .onLoad failed in loadNamespace() for 'rJava', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/usr/lib/R/site-library/rJava/libs/rJava.so':
  libjvm.so: cannot open shared object file: No such file or directory
```

And after all, a couple lines of R code to get some data from the stream:

```r
library(rJava)
library(AWR.Kinesis)
records <- kinesis_get_records('crypto', 'eu-west-1')
str(records)
records[1]

library(jsonlite)
fromJSON(records[1])
```

**Exercise**: 

* parse the loaded 25 records into a `data.table` object with proper column types. Get some help on the data format from the [Binance API docs](https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md#trade-streams)!
* count the overall number of units exchanged
* count the overall value of transactions in USD (hint: `binance_ticker_all_prices()` and `binance_coins_prices()`)
* visualize the distribution of symbol pairs




## Feedback

We are continuously trying to improve the content of this class and looking forward to any feedback and suggestions: https://gdaroczi.typeform.com/to/gDz58K
