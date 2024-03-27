Here you can find the materials for the "[Data Engineering 3: Batch Jobs and APIs](https://courses.ceu.edu/courses/2023-2024/data-engineering-3-batch-jobs-and-apis)" course, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous editions, see [2017/2018](https://github.com/daroczig/CEU-R-prod/tree/2017-2018), [2018/2019](https://github.com/daroczig/CEU-R-prod/tree/2018-2019), [2019/2020](https://github.com/daroczig/CEU-R-prod/tree/2019-2020), [2020/2021](https://github.com/daroczig/CEU-R-prod/tree/2020-2021), [2021/2022](https://github.com/daroczig/CEU-R-prod/tree/2021-2022), [2022/2023](https://github.com/daroczig/CEU-R-prod/tree/2022-2023).

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

* [Homeworks](#homeworks)
* [Home assignment](#home-assignment)
* [Getting help](#getting-help)

## Schedule

2 x 3 x 100 mins on March 20 and 27:

* 13:30 - 15:10 session 1
* 15:10 - 15:40 break
* 15:40 - 17:20 session 2
* 17:20 - 17:40 break
* 17:40 - 19:20 session 3

## Location

In-person at the Vienna campus (QS B-421).

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

1. You need a laptop with any operating system and stable Internet connection.
2. Please make sure that Internet/network firewall rules are not limiting your access to unusual ports (e.g. 22, 8787, 8080, 8000), as we will heavily use these in the class (can be a problem on a company network). CEU WiFi should have the related firewall rules applied for the class.
3. Please install Slack, and join the #﻿ba-de3-2023 channel in the `ceu-bizanalytics` group.
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
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.1-402-amd64.deb
    sudo apt install -y gdebi-core
    sudo gdebi rstudio-server-2023.12.1-402-amd64.deb
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
10. Custom port (e.g. 80): http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

    ```sh
    echo "www-port=80" | sudo tee -a /etc/rstudio/rserver.conf
    sudo rstudio-server restart

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
    sudo add-apt-repository "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main"
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
        sudo apt-get install -y r-cran-devtools r-cran-data.table r-cran-httr r-cran-jsonlite r-cran-data.table r-cran-stringi r-cran-stringr r-cran-glue r-cran-logger r-cran-snakecase
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

    6. Compare prices of 4 currencies (eg BTC, ETH, BNB and XRP) in the past 24 hours on 15 mins intervals:

        ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-3.png)

        <details><summary>Click here for the code generating the above ...</summary>

        ```r
        library(data.table)
        klines <- rbindlist(lapply(
            c('BTCUSDT', 'ETHUSDT', 'BNBUSDT', 'XRPUSDT'),
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
    sudo apt install -y fontconfig openjdk-17-jre

    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y jenkins

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

Note that if loading Jenkins after getting a new IP takes a lot of time, it might be due to
not be able to load the `theme.css` as trying to search for that on the previous IP (as per
Jenkins URL setting). To overcome this, wait 2 mins for the `theme.css` timeout, login, disable
the dark theme: https://github.com/jenkinsci/dark-theme-plugin/issues/458

### Schedule R commands

Let's schedule a Jenkins job to check on the Bitcoin prices every hour!

1. Log in to Jenkins using your instance's public IP address and port 8080
2. Use the `ceu` username and set a password (note this user is a virtual one, not the same as the user in shell)
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

    Either start R in the terminal as the root user (via `sudo R`) and run the previous `devtools::install_github` command there, or with a one-liner:

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
    ggsave('btc.png', plot = g, width = 10, height = 5)
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
    6. Run the job
    7. Look at the workspace that can be accessed from the sidebar menu of the job.

## Week 2

Quiz: https://forms.gle/ETsssYaXgHgRgHneA (10 mins)

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
5. Pick `t3a.medium` (4 GiB of RAM should be enough for most tasks) instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
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

### ScheduleR improvements

1. Note that a `crypto.R` file has been placed in your home folder. We can make use of that in Jenkins to run every 5 minutes. Edit the "btc price" job in Jenkins, and fix the path of the file in the Build Steps, then enable the "Build periodically" trigger:

    ```
        H/5 * * * *
    ```

2. Find the generated plot! It's in the Workspace (left sidebar of the project). Note that the aspect ratio is not great, fix in in the R script as per below:

    ```r
    ggsave('btc.png', plot = g, width = 10, height = 5)
    ```

3. Let find a better way to track changes in the file, e.g.
4. Use a git repository to store the R scripts and fetch the most recent version on job start:

    1. Configure the Jenkins job to use "Git" in the "Source Code Management" section, and use e.g. https://gist.github.com/daroczig/e5d3ee3664549932bb7f23ce8e93e472 as the repo URL, and specify the branch (`main`).
    2. Update the Execute task section to refer to the `btcprice.R` file of the repo instead of the hardcoded local path.
        ```
        Rscript btcprice.R
        ```

    3. Make edits to the repo, e.g. update lookback to 3 hours and check a future job output.

4. 💪 Configure notifications via eg https://app.mailjet.com/signin or https://resend.com

    1. Sign up, confirm your e-mail address and domain
    2. Take a note on the SMTP settings, eg

        * SMTP server: in-v3.mailjet.com
        * Port: 465
        * SSL: Yes
        * Username: ***
        * Password: ***

        or

        * SMTP server: smtp.resend.com
        * Port: 465
        * SSL: Yes
        * Username: resend
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

7. Attach the plot to the email on Success.
8. Look at other Jenkins plugins, eg the Slack Notifier: https://plugins.jenkins.io/slack

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
    - Make both scripts available in git (e.g. as a gist)

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

1. Join the #ba-de3-2023-bots channel in the `ceu-bizanalytics` Slack
2. 💪 A custom Slack app is already created at https://ceu-bizanalytics.slack.com/services/B0101G5EDS4, but feel free to create a new one and use the related app in the following steps
3. Look up the app's bots in the sidebar
4. Look up the API Token

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
5. 💪 Grant access to that KMS key by creating an EC2 IAM role at https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles with the `AWSKeyManagementServicePowerUser` policy and explicit grant access to the key in the KMS console
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

* Create a Jenkins job to alert if Bitcoin price is below $60K or higher than $65K.
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
if (btc < 60000 | btc > 65000) {
  library(botor)
  botor(region = 'eu-west-1')
  token <- ssm_get_parameter('slack')
  library(slackr)
  slackr_setup(username = 'jenkins', token = token, icon_emoji = ':jenkins-rage:')
  slackr_msg(
    text = paste('uh ... oh... BTC price:', btc),
    channel = '#ba-de3-2023-bots')
}
```

</details>

### Make API endpoints

1. 💪 Install plumber: [rplumber.io](https://www.rplumber.io)

    ```sh
    sudo apt install -y r-cran-plumber
    ```

2. Create an API endpoint to show the min, max and mean price of a BTC in the past hour!

    Create `~/plumber.R` with the below content:

    ```r
    library(binancer)

    #* BTC stats
    #* @get /btc
    function() {
      klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60L)
      klines[, .(min = min(close), mean = mean(close), max = max(close))]
    }
    ```

    Start the plumber application wither via clicking on the "Run API" button or the below commands:

    ```r
    library(plumber)
    pr("plumber.R") %>% pr_run(host='0.0.0.0', port=8000)
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

4. Add a new API endpoint to generate a HTML report including both the above!

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

Try to DRY (don't repeat yourself!) this up as much as possible. Attend the "Mastering R" class to learn more :)

### R API containers

Bundle all the scripts into a single Docker image:

1. 💪 Install Docker:

```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce
```

2. Create a new file named `Dockerfile` (File/New file/Text file to avoid auto-adding the `R` file extension) with the below content to add the required files and set the default working directory to the same folder:

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

3. Build the Docker image:

```sh
sudo docker build -t btc-report-api .
```

4. Run a container based on the above image:

```sh
sudo docker run -p 8000:8000 -ti btc-report-api plumber.R
```

5. Test by visiting the `8000` port or the Nginx proxy at http://de3.ceudata.net/8000, e.g. Swagger docs at http://de3.ceudata.net/8000/__docs__/#/default/get_report or an endpoint directly at http://de3.ceudata.net/8000/report.

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



## Homeworks

### Week 1

Read the [rOpenSci Docker tutorial](https://ropenscilabs.github.io/r-docker-tutorial/) -- quiz next week! Think about why we might want to use Docker.

## Getting help

Contact Gergely Daroczi on the `ceu-bizanalytics` Slack channel or
open a [GitHub ticket](https://github.com/daroczig/CEU-R-prod/issues).
