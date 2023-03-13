Here you can find the materials for the "[Data Engineering 3: Using R in Production](https://courses.ceu.edu/courses/2021-2022/data-engineering-3-using-r-production)" course, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous editions, see [2017/2018](https://github.com/daroczig/CEU-R-prod/tree/2017-2018), [2018/2019](https://github.com/daroczig/CEU-R-prod/tree/2018-2019), [2019/2020](https://github.com/daroczig/CEU-R-prod/tree/2019-2020), [2020/2021](https://github.com/daroczig/CEU-R-prod/tree/2020-2021), [2021/2022](https://github.com/daroczig/CEU-R-prod/tree/2021-2022).

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Schedule](#schedule)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class Schedule](#class-schedule)

   * [Week 1](#week-1)
      * [Background: Example use-cases and why to use R in the cloud?](#background-example-use-cases-and-why-to-use-r-in-the-cloud)
      * [Welcome to AWS!](#welcome-to-aws)
      * [Getting access to EC2 boxes](#getting-access-to-ec2-boxes)
      * [Create and connect to an EC2 box](#create-and-connect-to-an-ec2-box)
      * [Install RStudio Server on EC2](#install-rstudio-server-on-ec2)
      * [Connect to the RStudio Server](#connect-to-the-rstudio-server)
      * [Play with R for a bit](#play-with-r-for-a-bit)
      * [Prepare to schedule R commands](#prepare-to-schedule-r-commands)
      * [Schedule R commands](#schedule-r-commands)
      * [Schedule R scripts](#schedule-r-scripts)
      * [Make API endpoints](#make-api-endpoints)

   * [Week 2](#week-2)
      * [Recap](#recap)
      * [Amazon Machine Images](#-amazon-machine-images)
      * [Create a user for every member of the team](#-create-a-user-for-every-member-of-the-team)
      * [Update Jenkins for shared usage](#-update-Jenkins-for-shared-usage)
      * [Set up an easy to remember IP address](#-set-up-an-easy-to-remember-ip-address)
      * [Set up an easy to remember domain name](#-set-up-an-easy-to-remember-domain-name)
      * [Configuring for standard ports](#-configuring-for-standard-ports)
      * [ScheduleR improvements](#-scheduler-improvements)
      * [Intro to redis](#intro-to-redis)
      * [Interacting with Slack](#interacting-with-slack)
         * [Note on storing the Slack token](#note-on-storing-the-slack-token)
         * [Using Slack from R](#using-slack-from-r)
      * [Job Scheduler exercises](#job-scheduler-exercises)
      * [R API containers](#r-api-containers)
      * [Docker registry](#docker-registry)
      * [Docker service](#docker-service)

* [Homeworks](#homeworks)
* [Home assignment](#home-assignment)

* [Extra: Stream processing using R and AWS](#extra--stream-processing-using-r-and-aws)

  * [Setting up a demo stream](#-setting-up-a-demo-stream)
  * [A simple stream consumer app in R](#a-simple-stream-consumer-app-in-r)
  * [Parsing and structuring records read from the stream](#parsing-and-structuring-records-read-from-the-stream)
  * [Actual stream processing instead of analyzing batch data][#actual-stream-processing-instead-of-analyzing-batch-data]
  * [Stream processor daemon](#stream-processor-daemon)
  * [Shiny app showing the progress](#shiny-app-showing-the-progress)

* [Getting help](#getting-help)

## Schedule

2 x 3 x 100 mins on March 6 and 13:

* 13:30 - 15:10 session 1
* 15:10 - 15:40 break
* 15:40 - 17:20 session 2
* 17:20 - 17:40 break
* 17:40 - 19:20 session 3

## Location

In-person at the Vienna campus (QS B-511).

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

1. You need a laptop with any operating system and stable Internet connection.
2. Please make sure that Internet/network firewall rules are not limiting your access to unusual ports (e.g. 22, 8787, 8080, 8000), as we will heavily use these in the class (can be a problem on a company network). CEU WiFi should have the related firewall rules applied for the class.
3. Please install Slack, and join the #﻿ba-de3-2022 channel in the `ceu-bizanalytics` group.
4. When joining remotely, it's highly suggested to get a second monitor where you can follow the online stream, and keep your main monitor for your own work. The second monitor could be an external screen attached to your laptop, e.g. a TV, monitor, projector, but if you don't have access to one, you may also use a tablet or phone to dial-in to the Zoom call.

## Class Schedule

Will be updated from week to week.

## Week 1

**Goal**: learn how to run and schedule R jobs in the cloud.

### Background: Example use-cases and why to use R in the cloud?

Excerpts from https://daroczig.github.io/talks

* "A Decade of Using R in Production" (Real Data Science USA - R meetup)
* "Getting Things Logged" (RStudio::conf 2020)
* "Analytics databases in a startup environment: beyond MySQL and Spark" (Budapest Data Forum 2018)

### Welcome to AWS!

1. Use the following sign-in URL to access the class AWS account: https://657609838022.signin.aws.amazon.com/console
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

## Getting access to EC2 boxes

**Note**: we follow the instructions on Windows in the Computer Lab, but please find below how to access the boxes from Mac or Linux as well when working with the instances remotely.

1. Create (or import) an SSH key in AWS (EC2 / Key Pairs): https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName including using the Owner tag!
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

1. Create an EC2 instance

    0. Optional: create an Elastic IP for your box
    1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
    2. Click "Launch Instance"
    3. Provide a name for your server (e.g. `daroczig-de3-week1`) and some additional tags for resource tracking, including tagging downstream services, such as Instance and Volumes:
        * Class: `DE3`
        * Owner: `daroczig`
    4. Pick the `Ubuntu Server 22.04 LTS (HVM), SSD Volume Type` AMI
    5. Pick `t3a.small` (2 GiB of RAM should be enough for most tasks) instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
    6. Select your AWS key created above and launch
    7. Pick a unique name for the security group after clicking "Edit" on the "Network settings"
    8. Click "Launch instance"
    9. Note and click on the instance id

2. Connect to the box

    1. Specify the hostname or IP address

    ![](hhttps://docs.aws.amazon.com/AWSEC2/latest/UserGuide/images/putty-session-config.png)

    2. Specify the "Private key file for authentication" in the Connection category's SSH/Auth/Credentials pane
    3. Set the username to `ubuntu` on the Connection/Data tab
    4. Save the Session profile
    5. Click the "Open" button
    6. Accept & cache server's host key

Alternatively, you can connect via a standard SSH client on a Mac or Linux, something like:

```sh
chmod 0400 /path/to/your/pem
ssh -i /path/to/your/pem -p 8000 ubuntu@ip-address-of-your-machine
```

As a last resort, use "EC2 Instance Connect" from the EC2 dashboard by clicking "Connect" in the context menu of the instance (triggered by right click in the table).

### Install RStudio Server on EC2

1. Look at the docs: https://www.rstudio.com/products/rstudio/download-server
2. First, we will upgrade the system to the most recent version of the already installed packages. Note, check on the concept of a package manager!

    Download Ubuntu `apt` package list:

    ```sh
    sudo apt update
    ```

    Optionally upgrade the system:

    ```sh
    sudo apt upgrade
    ```

    And optionally also reboot so that kernel upgrades can take effect.

3. Install R

    ```sh
    sudo apt install r-base
    ```

    To avoid manually answering "Yes" to the question to confirm installation, you can specify the `-y` flag:

    ```sh
    sudo apt install -y r-base
    ```


4. Try R

    ```sh
    R
    ```

    For example:

    ```r
    1 + 4
    hist(mtcars$hp)
    # duh, where is the plot?!
    ```

    Exit:

    ```r
    q()
    ```

    Look at the files:

    ```sh
    ls
    ls -latr
    ```

5. Install RStudio Server

    ```sh
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2022.12.0-353-amd64.deb
    sudo apt install -y gdebi-core
    sudo gdebi rstudio-server-2022.12.0-353-amd64.deb
    ```

6. Check process and open ports

    ```sh
    rstudio-server status
    sudo rstudio-server status
    sudo systemctl status rstudio-server
    sudo ps aux | grep rstudio

    sudo apt -y install net-tools
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
4. Open up port 8787 in the security group, by selecting your security group and click "Edit inbound rules":

    ![](https://user-images.githubusercontent.com/495736/222724348-869d0703-05f2-4ef3-bd80-574362e73265.png)

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

Note 1: might need to relogin / restart RStudio / reload R / reload page .. to force a new shell login so that the updated group setting is applied
Note 2: you might want to add `NOPASSWD` to the `sudoers` file:

    ```sh
    ceu ALL=(ALL) NOPASSWD:ALL
    ```

Although also note (3) the related security risks.

9. Custom login page: http://docs.rstudio.com/ide/server-pro/authenticating-users.html#customizing-the-sign-in-page
10. Custom port: http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

### Play with R for a bit

0. Note the pretty outdated R version ... so let's update R:

    ```sh
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

    ## fetch most recent list of packages and version, then auto-upgrade
    sudo apt-get update && sudo apt-get -y upgrade
    ```

    Now try R in the console, then restart R in RStudio (Session/Quit Session). Also a good time to clean up the Terminal (brush icon in the top right of the panel).

1. Installing packages:

    ```sh
    ## don't do this at this point!
    ## install.packages('ggplot2')
    ```

2. Use binary packages instead as per https://github.com/eddelbuettel/r2u

    ```sh
    wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | sudo tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc
    echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main" | sudo tee -a  /etc/apt/sources.list.d/cranapt.list
    sudo apt update

    sudo apt-get install -y r-cran-ggplot2
    ```

    Note that all dependencies (let it be an R package or system/Ubuntu package) have been automatically resolved and installed.

    Don't forget to click on the brush icon to clean up your terminal output if needed.

    Optionally [enable `bspm`](https://github.com/eddelbuettel/r2u#step-5-use-bspm-optional) to enable binary package installations via the traditional `install.packages` R function.

3. Ready to use it from R after restarting the session:

    ```r
    library(ggplot2)
    ggplot(mtcars, aes(hp)) + geom_histogram()
    ```

4. Get some real-time data and visualize it:

    1. Install the `devtools` R package and a few others (binary distribution) in the RStudio/Terminal:

        ```sh
        sudo apt-get install -y r-cran-devtools r-cran-data.table r-cran-httr r-cran-jsonlite r-cran-data.table r-cran-stringi r-cran-stringr r-cran-glue
        ```

    2. Switch back to the R console and install the `binancer` R package from GitHub to interact with crypto exchanges (note the extra dependency to be installed from CRAN, no need to update any already installed package):

        ```r
        devtools::install_github('daroczig/binancer', upgrade = FALSE)
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

### Prepare to schedule R commands

![](https://wiki.jenkins-ci.org/download/attachments/2916393/fire-jenkins.svg)

1. Install Jenkins from the RStudio/Terminal: https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

    ```sh
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install -y openjdk-11-jre-headless
    sudo apt install -y jenkins
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
2. Use the `ceu` username and `ceudata` password (note this user is a virtual one, not the same as the user in shell)
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
    sudo Rscript -e "library(devtools);withr::with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/binancer', upgrade = FALSE))"
    ```

6. Rerun the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2018-2019/images/jenkins-success.png)

7. Optionally set up E-mail and Slack notification for the job success/error:

    1. Scroll down in the job config to the "Post-build Actions" section
    2. Add "Editable email notification", then fill in the "Project Recipient List" with an email address, and click "Advanced Settings" to define the triggers (e.g. send email on success or failure, and if you want to attach anything to the email).
    3. Add "Slack notifications" and configure the triggers, all the other details (e.g. which Slack channel to report to and Slack username etc have been configured globally, so although you can override, but no need to).

### Schedule R scripts

1. Create an R script with the below content and save on the server, eg as `/home/ceu/bitcoin-price.R`:

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    paste('The current Bitcoin price is', prices[symbol == 'BTC', usd])
    ```

2. Follow the steps from the [Schedule R commands](#schedule-r-commands) section to create a new Jenkins job, but instead of calling `R -e "..."` in shell step, reference the above R script using `Rscript` instead:

    ```shell
    Rscript /home/ceu/de3.R
    ```

    Alternatively, you could also install little R for this purpose:

    ```shell
    sudo apt install -y r-cran-littler
    r /home/ceu/de3.R
    ```

    Note the permission error, so let's add the `jenkins` user to the `ceu` group:

    ```shell
    sudo adduser jenkins ceu
    ```

    Then restart Jenkins from the RStudio Server terminal:

    ```shell
    sudo systemctl restart jenkins
    ```

    A better solution will be later to commit our R script into a git repo, and make it part of the job to update from the repo.

3. Create an R script that generates a candlestick chart on the BTC prices from the past hour, saves as `btc.png` in the workspace, and update every 5 minutes!

    <details><summary>Example solution for the above ...</summary>

    ```r
    library(binancer)
    library(ggplot2)
    library(scales)
    klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60)
    g <- ggplot(klines, aes(open_time)) +
            geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
            geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
            theme_bw() + theme('legend.position' = 'none') + xlab('') +
            ggtitle(paste('Last Updated:', Sys.time())) +
            scale_y_continuous(labels = dollar) +
            scale_color_manual(values = c('#1a9850', '#d73027'))
    ggsave('btc.png', plot = g)
    ```
    </details>

    1. Enter the name of the job: `Update BTC candlestick chart`
    2. Pick "Freestyle project"
    3. Click "OK"
    4. Add a new "Execute shell" build step
    5. Enter the below command to look up the most recent BTC price

        ```sh
        Rscript /home/ceu/plot.R
        ```

    6. Enable the "Build periodically" trigger:

        ```
        H/* * * * *
        ```

    7. Run the job
    8. Look at the workspace that can be accessed from the sidebar menu of the job.

### Make API endpoints


1. Install plumber: [rplumber.io](https://www.rplumber.io)

    ```sh
    sudo apt install -y r-cran-plumber
    ```

2. Create an API endpoint to show the min, max and mean price of a BTC in the past hour!

    Create `/home/ceu/plumber.R` with the below content:

    ```r
    library(binancer)

    #* BTC stats
    #* @get /btc
    function() {
      klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60L)
      klines[, .(min = min(close), mean = mean(close), max = max(close))]
    }
    ```

    Start the plumber application:

    ```r
    library(plumber)
    pr("plumber.R") %>% pr_run(port=8000)
    ```

3. Add a new API endpoint to generate the candlestick chart with dynamic symbol (default to BTC), interval and limit! Note that you might need a new `@serializer`, function arguments, and type conversions as well.

    <details><summary>Example solution for the above ...</summary>

    ```r
    library(binancer)
    library(ggplot2)
    library(scales)

    #* Generate plot
    #* @param symbol coin pair
    #* @param interval:str enum
    #* @param limit integer
    #* @get /klines
    #* @serializer png
    function(symbol = 'BTCUSDT', interval = '1m', limit = 60L) {
      klines <- binance_klines(symbol, interval = interval, limit = as.integer(limit)) # NOTE int conversion
      library(scales)
      p <- ggplot(klines, aes(open_time)) +
        geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
        geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
        theme_bw() + theme('legend.position' = 'none') + xlab('') +
        ggtitle(paste('Last Updated:', Sys.time())) +
        scale_y_continuous(labels = dollar) +
        scale_color_manual(values = c('#1a9850', '#d73027')) # RdYlGn
      print(p)
    }
    ```
    </details>

Next week:

* Create an Amazon Machine Image for production use, including a shared Jenkins and RStudio server.
* Productionalize Jenkins with email and Slack notifications.
* Deploy Plumber as a cloud service.
* Get to work a bit with databases.
* Intro to stream processing.

Please terminate your EC2 node if you are not using it anymore!

## Week 2

Quiz: let's revisit when all students are around.

Quiz: https://forms.gle/d1nQov1rr1wCriTu7 (10 mins)

Interesting updates from the R/infra community from the past week: [webR](https://www.tidyverse.org/blog/2023/03/webr-0-1-0/#using-webr-in-your-own-projects).

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
11. Setting up an R-based API

Note that you do NOT need to do the instructions below marked with the :muscle: emoji -- those have been already done for you, and the related steps are only included below for documenting what has been done and demonstrated in the class.

### Amazon Machine Images

💪 Instead of starting from scratch, let's create an Amazon Machine Image (AMI) from the EC2 node we used last week, so that we can use that as the basis of all the next steps:

* Find the EC2 node in the EC2 console
* Right click, then "Image and tempaltes" / "Create image"
* Name the AMI and click "Create image"
* It might take a few minutes to finish

Then you can use the newly created `de3` AMI to spin up a new instance for you:

1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
2. Click "Launch Instance"
3. Provide a name for your server (e.g. `daroczig-de3-week2`) and some additional tags for resource tracking, including tagging downstream services, such as Instance and Volumes:
    * Class: `DE3`
    * Owner: `daroczig`
4. Pick the `de3` AMI
5. Pick `t3a.small` (2 GiB of RAM should be enough for most tasks) instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
6. Select your AWS key created above and launch
7. Select the `de3` security group
8. click "Advanced details" and select `ceudataserver` IAM instance profile
9. Click "Launch instance"
10. Note and click on the instance id

### 💪 Create a user for every member of the team

We'll export the list of IAM users from AWS and create a system user for everyone.

1. Attach a newly created IAM EC2 Role (let's call it `ceudataserver`) to the EC2 box and assign 'Read-only IAM access' (`IAMReadOnlyAccess`):

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

### 💪 Update Jenkins for shared usage

Update the security backend to use real Unix users for shared access (if users already created):

![](https://user-images.githubusercontent.com/495736/224517493-652ac34e-f44d-4ac9-8d04-d661dcfc4c4b.png)

And allow `jenkins` to authenticate UNIX users and restart:

```sh
sudo adduser jenkins shadow
sudo systemctl restart jenkins
```

Then make sure to test new user access in an incognito window to avoid closing yourself out :)

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

    - fill in the desired `Name` (subdomain), eg `de3.ceudata.net`
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create`

4. Now you will be able to access your box using this custon (sub)domain, no need to remember IP addresses.

### 💪 Configuring for standard ports

To avoid using ports like `8787` and `8080` (and get blocked by the firewall installed on the CEU WiFi), let's configure our services to listen on the standard 80 (HTTP) and potentially on the 443 (HTTPS) port as well, and serve RStudio on the `/rstudio`, and Jenkins on the `/jenkins` path.

For this end, we will use Nginx as a reverse-proxy, so let's install it first:

```shell
sudo apt install -y nginx
```

First, we need to edit the Nginx config to enable websockets for Shiny apps etc in `/etc/nginx/nginx.conf` under the `http` section:

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
    location / {

    }
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

And we also need to let Jenkins also know about the custom path, so uncomment `Environment="JENKINS_PREFIX=/jenkins"` in `/lib/systemd/system/jenkins.service`, then reload the Systemd configs and restart Jenkins:

```shell
sudo systemctl daemon-reload
sudo systemctl restart jenkins
```

See more details at the [Jenkins reverse proxy guide](https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-with-jenkins/reverse-proxy-configuration-nginx/).

Optionally, replace the default, system-wide `index.html` for folks visiting the root domain without either the `rstudio` or `jenkins` path (note that instead of the editing the file, which might be overwritten with package updates, it would be better to create a new HTML file and refer that from the Nginx configuration, but we will keep it simple and dirty for now):

```shell
echo "Welcome to DE3! Are you looking for <code>/rstudio</code> or <code>/jenkins</code>?" | sudo tee /usr/share/nginx/html/index.html
```

Then restart Jenkins, and good to go!

It might be useful to also proxy port 8000 for future use via updating the Nginx config to:

```
server {
    listen 80;
    rewrite ^/rstudio$ $scheme://$http_host/rstudio/ permanent;
    location / {

    }
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
    location ^~ /8000/ {
      rewrite ^/8000/(.*)$ /$1 break;
      proxy_pass http://127.0.0.1:8000;
      proxy_set_header X-Real-IP  $remote_addr;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Host $host;
    }
}
```


This way you can access the above services via the below URLs:

RStudio Server:

* http://your.ip.address:8787
* http://your.ip.address/rstudio

Jenkins:

* http://your.ip.address:8080/jenkins
* http://your.ip.address/jenkins

Port 8000:

* http://your.ip.address:8000
* http://your.ip.address/8000

If you cannot access RStudio Server on port 80, you might need to restart `nginx` as per above.

Next, set up SSL either with Nginx or placing an AWS Load Balancer in front of the EC2 node.

### 💪 ScheduleR improvements

1. Use a git repository to store the R scripts and fetch the most recent version on job start:

    1. Configure the Jenkins job to use "Git" in the "Source Code Management" section, and use e.g. https://gist.github.com/daroczig/e5d3ee3664549932bb7f23ce8e93e472 as the repo URL, and specify the branch (`main`).
    2. Update the Execute task section to refer to the `btcprice.R` file of the repo instead of the hardcoded local path.
    3. Make edits to the repo, e.g. update lookback to 3 hours and check a future job output.

2. Set up e-mail notifications via eg https://app.mailjet.com/signin

    1. Sign up, confirm your e-mail address and domain
    2. Take a note on the SMTP settings, eg

        * SMTP server: in-v3.mailjet.com
        * Port: 465
        * SSL: Yes
        * Username: ***
        * Password: ***

    3. Configure Jenkins at http://de3.ceudata.net/jenkins/configure

        1. Set up the default FROM e-mail address at "System Admin e-mail address": jenkins@ceudata.net
        2. Search for "Extended E-mail Notification" and configure

           * SMTP Server
           * Click "Advanced"
           * Check "Use SMTP Authentication"
           * Enter User Name from the above steps
           * Enter Password from the above steps
           * Check "Use SSL"
           * SMTP port: 465

    5. Set up "Post-build Actions" in Jenkins: Editable Email Notification - read the manual and info popups, configure to get an e-mail on job failures and fixes
    6. Configure the job to send the whole e-mail body as the deault body template for all outgoing emails

    ```shell
    ${BUILD_LOG, maxLines=1000}
    ```

3. Look at other Jenkins plugins, eg the Slack Notifier: https://plugins.jenkins.io/slack

### Intro to redis

We need a persistent storage for our Jenkins jobs ... let's give a try to a key-value database:

1. 💪 Install server

   ```
   sudo apt install redis-server
   netstat -tapen | grep LIST
   ```

   Test using the CLI tool:

   ```
   redis-cli get foo
   redis-cli set foo 42
   redis-cli get foo
   redis-cli del foo
   ```

2. 💪 Install an R client

    Although we could use the `RcppRedis` available on CRAN, so thus also in our already added apt repo, but `rredis` provides some convenient helpers that we plan to use, so we are going to install that as well from a custom R package repository to also demonstrate how `drat` works:

    ```
    sudo apt install -y r-cran-rcppredis
    sudo Rscript -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('rredis', repos=c('https://ghrr.github.io/drat', 'https://cloud.r-project.org')))"
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

    ## drop all keys
    redisDelete(redisKeys())
    ```

For more examples and ideas, see the [`rredis` package vignette](https://rdrr.io/cran/rredis/f/inst/doc/rredis.pdf) or try the interactive, genaral (not R-specific) [redis tutorial](https://try.redis.io).

4. Exercises

    - Create a Jenkins job running every minute to cache the most recent Bitcoin and Ethereum prices in Redis
    - Write an R script in RStudio that can read the Bitcoin and Ethereum prices from the Redis cache

<details><summary>Example solution ...</summary>

```r
library(binancer)
library(data.table)
prices <- binance_coins_prices()

library(rredis)
redisConnect()


redisSet('username:price:BTC', prices[symbol == 'BTC', usd])
redisSet('username:price:ETH', prices[symbol == 'ETH', usd])

redisGet('username:price:BTC')
redisGet('username:price:ETH')

redisMGet(c('username:price:BTC', 'username:price:ETH'))
```
</details>

<details><summary>Example solution using a helper function doing some logging ...</summary>

```r
library(binancer)
library(logger)
library(rredis)
redisConnect()

store <- function(s) {
  ## TODO use the checkmate pkg to assert the type of symbol
  log_info('Looking up and storing {s}')
  value <- binance_coins_prices()[symbol == s, usd]
  key <- paste('username', 'price', s, sep = ':')
  redisSet(key, value)
  log_info('The price of {s} is {value}')
}

store('BTC')
store('ETH')

## list all keys with the "price" prefix and lookup the actual values
redisMGet(redisKeys('username:price:*'))
```
</details>

More on databases at the "Mastering R" class in the Spring semester ;)

### Interacting with Slack

1. Join the #ba-de3-2021-bots channel in the `ceu-bizanalytics` Slack
2. 💪 A custom Slack app is already created at https://ceu-bizanalytics.slack.com/services/B0101G5EDS4, but feel free to create a new one and use the related app in the following steps
3. Look up the app's bots in the sidebar
4. Look up the Access Token

#### Note on storing the Slack token

1. Do not store the token in plain-text!
2. Let's use Amazon's Key Management Service: https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (slides 73-75)
3. 💪 Instead of using the Java SDK referenced in the above talk, let's install `boto3` Python module and use via `reticulate`:

    ```shell
    sudo apt install -y python3-pip
    sudo pip3 install boto3
    sudo apt install -y r-cran-reticulate r-cran-botor
    ```

4. 💪 Create a key in the Key Management Service (KMS): `alias/de3`
5. Grant access to that KMS key by creating an EC2 IAM role at https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles with the `AWSKeyManagementServicePowerUser` policy and explicit grant access to the key in the KMS console
6. Attach the newly created IAM role
7. Use this KMS key to encrypt the Slack token:

    ```r
    library(botor)
    botor(region = 'eu-west-1')
    kms_encrypt('token', key = 'alias/de3')
    ```

    Note, if R asks you to install Miniconda, say NO, as Python3 and the required packages have already been installed system-wide.

8. Store the ciphertext and use `kms_decrypt` to decrypt later, see eg

    ```r
    kms_decrypt("AQICAHgzIk6iRoD8yYhFk//xayHj0G7uYfdCxrW6ncfAZob2MwHNrEj6Uxlfg1MmD+ImwvYTAAAAmjCBlwYJKoZIhvcNAQcGoIGJMIGGAgEAMIGABgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDNM5AhEiMBUacg2f2AIBEIBTgvo4Z9+/ayuYnKNFQpICgV9H06u7plFFT/cSk4KUslnj2i8Xn9bgmQWSep0USG3NK1jR+DweQpxvh18/OO+pSiIII+O1yiv5Ql5R4EozjhmGGBY=")
    ```

9. 💪 Alternatively, use the AWS Parameter Store or Secrets Manager, see eg https://eu-west-1.console.aws.amazon.com/systems-manager/parameters/?region=eu-west-1&tab=Table and granting the `AmazonSSMReadOnlyAccess` policy to your IAM role or user.

    ```r
    ssm_get_parameter('slack')
    ```

#### Using Slack from R

4. 💪 Install the Slack R client

    ```shell
    sudo apt install -y r-cran-slackr
    ```

5. Init and send our first messages with `slackr`

    ```r
    library(botor)
    botor(region = 'eu-west-1')
    token <- ssm_get_parameter('slack')
    library(slackr)
    slackr_setup(username = 'jenkins', token = token, icon_emoji = ':jenkins-rage:')
    slackr_msg(text = 'Hi there!', channel = '#ba-de3-2022-bots')
    ```

6. A more complex message

    ```r
    library(binancer)
    prices <- binance_coins_prices()
    msg <- sprintf(':money_with_wings: The current Bitcoin price is: $%s', prices[symbol == 'BTC', usd])
    slackr_msg(text = msg, preformatted = FALSE, channel = '#ba-de3-2022-bots')
    ```

7. Or plot

    ```r
    library(ggplot2)
    klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
    p <- ggplot(klines, aes(close_time, close)) + geom_line()
    ggslackr(plot = p, channels = '#ba-de3-2022-bots', width = 12)
    ```

### Job Scheduler exercises

* Create a Jenkins job to alert if Bitcoin price is below $20K or higher than $22K.
* Create a Jenkins job to alert if Bitcoin price changed more than $200 in the past hour.
* Create a Jenkins job to alert if Bitcoin price changed more than 5% in the past day.
* Create a Jenkins job running hourly to generate a candlestick chart on the price of BTC and ETH.

<details><summary>Example solution for the first exercise ...</summary>

```r
## get data right from the Binance API
library(binancer)
btc <- binance_klines('BTCUSDT', interval = '1m', limit = 1)$close

## or from the local cache (updated every minute from Jenkins as per above)
library(rredis)
redisConnect()
btc <- redisGet('username:price:BTC')

## log whatever was retreived
library(logger)
log_info('The current price of a Bitcoin is ${btc}')

## send alert
if (btc < 20000 | btc > 22000) {
  library(botor)
  botor(region = 'eu-west-1')
  token <- ssm_get_parameter('slack')
  library(slackr)
  slackr_setup(username = 'jenkins', token = token, icon_emoji = ':jenkins-rage:')
  slackr_msg(
    text = paste('uh ... oh... BTC price:', btc),
    channel = '#ba-de3-2022-bots')
}
```

</details>

### R API containers

Why API? Why R-based API? Examples

* adtech
* healthtech

1. Write an R script that provides 3 API endpoints (look up examples from past week!):

    * `/stats` reports on the min/mean/max BTC price from the past 3 hours
    * `/plot` generates a candlestick chart on the price of BTC from past 3 hours
    * `/report` generates a HTML report including both the above

    <details><summary>Example solution for the above ...</summary>

    💪 Update the `markdown` package:

    ```shell
    sudo apt install -y r-cran-markdown
    ```

    Create an R markdown for the reporting:

    `````md
    ---
    title: "report"
    output: html_document
    date: "`r Sys.Date()`"
    ---

    ```{r setup, include=FALSE}
    knitr::opts_chunk$set(echo = FALSE, warning=FALSE)
    library(binancer)
    library(ggplot2)
    library(scales)
    library(knitr)

    klines <- function() {
      binance_klines('BTCUSDT', interval = '1m', limit = 60L)
    }
    ```

    Bitcoin stats:

    ```{r stats}
    kable(klines()[, .(min = min(close), mean = mean(close), max = max(close))])
    ```

    On a nice plot:

    ```{r plot}
    ggplot(klines(), aes(open_time, )) +
      geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
      geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
      theme_bw() + theme('legend.position' = 'none') + xlab('') +
      ggtitle(paste('Last Updated:', Sys.time())) +
      scale_y_continuous(labels = dollar) +
      scale_color_manual(values = c('#1a9850', '#d73027'))
    ```
    `````

    And the plumber file:

    ```r
    library(binancer)
    library(ggplot2)
    library(scales)
    library(rmarkdown)
    library(plumber)

    #' Gets BTC data from the past hour
    #' @return data.table
    klines <- function() {
        binance_klines('BTCUSDT', interval = '1m', limit = 60L)
    }

    #* BTC stats
    #* @get /stats
    function() {
      klines()[, .(min = min(close), mean = mean(close), max = max(close))]
    }

    #* Generate plot
    #* @get /plot
    #* @serializer png
    function() {
      p <- ggplot(klines(), aes(open_time, )) +
        geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
        geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
        theme_bw() + theme('legend.position' = 'none') + xlab('') +
        ggtitle(paste('Last Updated:', Sys.time())) +
        scale_y_continuous(labels = dollar) +
        scale_color_manual(values = c('#1a9850', '#d73027')) # RdYlGn
      print(p)
    }

    #* Generate HTML
    #* @get /report
    #* @serializer html
    function(res) {
       filename <- tempfile(fileext = '.html')
       on.exit(unlink(filename))
       render('report.Rmd', output_file = filename)
       include_file(filename, res)
    }
    ```

    Run via:

    ```r
    library(plumber)
    pr('plumber.R') %>% pr_run(port = 8000)
    ```
    </details>

2. Try to DRY (don't repeat yourself!) this up as much as possible. Attend the "Mastering R" class to learn more :)
3. Bundle all the scripts into a single Docker image:

    a. 💪 Install Docker:

    ```shell
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce
    ```

    b. Create a new file named `Dockerfile` (File/New file/Text file to avoid auto-adding the `R` file extension) with the below content to add the required files and set the default working directory to the same folder:

    ```
    FROM rstudio/plumber

    RUN apt-get update && apt-get install -y pandoc && apt-get clean && rm -rf /var/lib/apt/lists/
    RUN install2.r ggplot2
    RUN installGithub.r daroczig/binancer
    ADD report.Rmd /app/report.Rmd
    ADD plumber.R /app/plumber.R
    EXPOSE 8000
    WORKDIR /app
    ```

    Note the the step installing the required R paackages!

    c. Build the Docker image:

    ```sh
    sudo docker build -t btc-report-api .
    ```

    d. Run a container based on the above image:

    ```sh
    sudo docker run -p 8000:8000 -ti btc-report-api plumber.R
    ```

    e. Test by visiting the `8000` port or the Nginx proxy at http://de3.ceudata.net/8000, e.g. Swagger docs at http://de3.ceudata.net/8000/__docs__/#/default/get_report or an endpoint directly at http://de3.ceudata.net/8000/report.

### Docker registry

Now let's make the above created and tested Docker image available outside of the RStudio Server by uploading the Docker image to Elastic Container Registry (ECR):

1. 💪 Create a new private repository at https://eu-west-1.console.aws.amazon.com/ecr/home?region=eu-west-1, call it `de3-example-api`
2. 💪 Assign the `EC2InstanceProfileForImageBuilderECRContainerBuilds` policy to the `ceudataserver` IAM role so that we get RW access to the ECR repositories. Tighten this role up in prod!
3. 💪 Let's login to ECR on the RStudio Server so that we can upload the Docker image:

    ```sh
    aws ecr get-login-password --region eu-west-1 | sudo docker login --username AWS --password-stdin 657609838022.dkr.ecr.eu-west-1.amazonaws.com
    ```

4. 💪 Tag the already build Docker image for upload:

    ```sh
    sudo docker tag btc-report-api:latest 657609838022.dkr.ecr.eu-west-1.amazonaws.com/de3-example-api:latest
    ```

5. 💪 Push the Docker image:

    ```sh
    sudo docker push 657609838022.dkr.ecr.eu-west-1.amazonaws.com/de3-example-api:latest
    ```

6. Check the Docker repository at https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/657609838022/de3-example-api?region=eu-west-1

### Docker service

1. Go to the Elastic Container Service (ECS) dashboard at https://eu-west-1.console.aws.amazon.com/ecs/home?region=eu-west-1#/
2. Create a task definition for the Docker run:

    1. Task name: `btc-api`
    2. Container name: `api`
    3. Image URI: `657609838022.dkr.ecr.eu-west-1.amazonaws.com/de3-example-api`
    4. Container port: 8000
    5. Command in the Docker configuration: `plumber.R`
    6. Review Task size, but default values should fine for this simple task

3. Create a new cluster, call it `BTC_API`, using Fargate. Don't forget to add the `Class` tag!
4. Create a Service in the newly created Cluster at https://eu-west-1.console.aws.amazon.com/ecs/v2/clusters/btc-api/services?region=eu-west-1

    1. Compute option can be "Launch type" for now
    2. Specify the Task Family as `btc-api`
    3. Provide the same as service name
    4. Use the `de3` security group
    5. Create a load balancer listening on port 80 (would need to create an SSL cert for HTTPS), and specify `/stats` as the healthcheck path, with a 10 seconds grace period
    6. Test the deployed service behind the load balancer, e.g. https://btc-api-1417435399.eu-west-1.elb.amazonaws.com/report

## Homeworks

### Week 1

Read the [rOpenSci Docker tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) -- quiz next week! Think about why we might want to use Docker.

## Home assignment

The goal of this assignment is to confirm that you have a general understanding on how to build data pipelines using Amazon Web Services and R, and can actually implement a stream processing application (either running in almost real-time or batched/scheduled way) or R-based API in practice.

### Tech setup

To minimize the system administration and some of the already-covered engineering tasks for the students, the below pre-configured tools are provided as free options, but students can decide to build their own environment (on the top of or independently from these) and feel free to use any other tools:

* `crypto` stream in the Ireland region of the central CEU AWS account with the real-time order data from the Binance cryptocurrency exchange on Bitcoin (BTC), Ethereum (ETH), Litecoin (LTC), Neo (NEO), Binance Coin (BNB) and Tether (USDT) -- including the the attributes of each transaction as specified at https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md#trade-streams
* `de3` Amazon Machine Image that you can use to spin up an EC2 node with RStudio Server, Shiny Server, Jenkins, Redis and Docker installed & pre-configured (use your AWS username and the password shared on Slack previously) along with the most often used R packages (including the ones we used for stream processing, eg `botor`, `AWR.Kinesis` and the `binancer` package)
* `de3` EC2 IAM role with full access to Kinesis, Dynamodb, Cloudwatch and the `slack` token in the Parameter Store
* `de3` security group with open ports for RStudio Server and Jenkins
* lecture and seminar notes at https://github.com/daroczig/CEU-R-prod

### Required output

Make sure to clean-up your EC2 nodes, security groups, keys etc created in the past weeks, as left-over AWS resources [will contribute negative points to your final grade](#preparations)! E.g. the EC2 node you created on the first week should be terminated.

* Minimal project (for grade up to "B"): schedule a Jenkins job that runs every hour getting the past hour's 1-minute interval klines data on ETH prices (in USD). The job should be configured to pull the R script at the start of the job either from a private or public git repo or gist. Then

    * Find the min and max price of ETH in the past hour, and post these stats in the `#bots-final-project` Slack channel. Make sure to set your username for the message, and use a custom emoji as the icon.
    * Find an R package that provides a function to draw candlestick charts, and use that to post a candlestick chart on the past hour's ETH price in the `#bots-final-project` Slack channel.

* Recommended project (for grade up to "A"): Deploy an R-based API in ECS (like we did on the last week) for analyzing recent Binance (or any other real-time) data. The API should include at least 4 endpoints using different serializers, and these endpoints should be other than the ones we covered in the class. At least one endpoint should have at least a few parameters. Build a Docker image, push it to ECR, and deploy as service in ECS. Document the steps required to set up ECR/ECS with screenshots, then delete all services after confirming that everything works correctly.

### Delivery method

* Create a PDF document that describes your solution and all the main steps involved with low level details: attach screenshots (including the URL nav bar and the date/time widget of your OS, so like full-screen and not area-picked screenshots) of your browser showing what you are doing in RStudio Server, Jenkins, or in the AWS dashboards, and make sure that the code you wrote is either visible on the screenshots, or included in the PDF.

* STOP the EC2 Instance you worked on, but don’t terminate it, so we can start it and check how it works. Note that your instance will be terminated by us after the end of the class.
* Include the `instance_id` on the first page of the PDF, along with your name or student id.
* Upload the PDF to Moodle.

### Submission deadline

Midnight (CET) on April 2, 2023.

## Extra: Stream processing using R and AWS

An introduction to stream processing with AWS Kinesis and R: https://github.com/daroczig/CEU-R-prod/raw/2017-2018/AWR.Kinesis/AWR.Kinesis-talk.pdf (presented at the Big Data Day Los Angeles 2016, EARL 2016 London and useR! 2017 Brussels)

This section describes how to set up a Kinesis stream with a few on-demand shards on the live Binance transactions read from its websocket -- running in a Docker container, then feeding the JSON lines to Kinesis via the Amazon Kinesis Agent.

### 💪 Setting up a demo stream

1. Start a `t3a.micro` instance running "Amazon Linux 2 AMI" (where it's easier to install the Kinesis Agent compared to using eg Ubuntu) with a known key. Make sure to **set a name** and enable termination protection (in the instance details)! Use SSH, Putty or eg the browser-based SSH connection. Note that the default username is `ec2-user` instead of `ubuntu`.

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
    sudo docker run -ti --rm --log-opt max-size=50m daroczig/ceu-de3-docker-binance-streamer >> /tmp/transactions.json
    ## "C-a c" to create a new screen, then you can switch with C-a "
    ls -latr /tmp
    tail -f /tmp/transactions.json
    ```

4. Install the Kinesis Agent:

    As per https://docs.aws.amazon.com/firehose/latest/dev/writing-with-agents.html#download-install:

    ```
    sudo yum install -y aws-kinesis-agent
    ```

5. Create a new Kinesis Stream (called `crypto`) at https://eu-west-1.console.aws.amazon.com/kinesis. Don't forget to tag it (Class, Owner)!

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
          "filePattern": "/tmp/transactions.json*",
          "kinesisStream": "crypto",
          "partitionKeyOption": "RANDOM"
        }
      ]
    }
    ```

    Note that extra star at the end of the `filePattern` to handle potential issues when file is copy/truncated (logrotate).

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
12. Optionally set up a cronjob to truncate that the file from time to time:

    ```sh
    5 * * * * /usr/bin/truncate -s 0 /tmp/transactions.json
    ```

13. Set up an alert in Cloudwatch if streaming stops

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
      redisIncr(paste('USERNAME', 'tx', symbol, sep = ':'))
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
    symbols <- redisMGet(redisKeys('^USERNAME:tx:*'))
    symbols

    symbols <- data.frame(
      symbol = sub('^USERNAME:tx:', '', names(symbols)),
      N = as.numeric(symbols))
    symbols
    ```

5. Visualize

    ```r
    library(ggplot2)
    ggplot(symbols, aes(symbol, N)) + geom_bar(stat = 'identity')
    ```

6. Rerun step (1) and (3) to do the data processing, then (4) and (5) for the updated data visualization.

7. 🤦

8. Let's make use of the next shard iterator:

    ```r
    ## reset counters
    redisDelete(redisKeys('USERNAME:tx:*'))

    ## get the first shard iterator
    shard_iterator <- kinesis_get_shard_iterator('crypto', '0')$ShardIterator

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
      symbols <- redisMGet(redisKeys('USERNAME:tx:*'))
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
    sudo apt install r-cran-awr.kinesis
    sudo R -e "withr::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('AWR', repos = 'https://daroczig.gitlab.io/AWR'))"
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
    sudo apt install r-cran-httpuv r-cran-shiny r-cran-xtable r-cran-htmltools r-cran-igraph r-cran-lubridate r-cran-tidyr r-cran-quantmod r-cran-broom r-cran-zoo r-cran-htmlwidgets r-cran-tidyselect r-cran-rlist r-cran-rlang r-cran-xml r-cran-treemap r-cran-highcharter
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

### Bonus exercise

Create a stream processing application using the `AWR.Kinesis` R package's daemon + Redis. This is very similar to what we did on the last week, but instead of counting the number of transactions per symbol, it should be the cumulative sum of traded amounts (so you should always increase the value with the traded quantity):

    * You should run your streaming app to process the Binance transactions, and update the values in Redis.
    * No need to clear the cache in Redis. E.g. if a symbol was not included in a batch, don't update the related values in Redis.
    * Create a Jenkins job that reads from Redis, and prints the overall value (in USD) of the transactions based on the coin prices reported by the Binance API at the time of the reporting.
    * The streaming process needs to run while you are working on the HO, to get new values into Redis.
    * Create at least two more additional charts that display a metric you find meaningful, and report in the "#bots-final-project" Slack channel.

## Getting help

Contact Gergely Daroczi and Mihaly Orsos on the `ceu-bizanalytics` Slack channel
or open a [GitHub ticket](https://github.com/daroczig/CEU-R-prod/issues) in this repo.
