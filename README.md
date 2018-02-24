Here you can find the materials for the 3rd and 4th week of the "[Data Infrastructure in Production](https://economics.ceu.edu/courses/data-infrastructure-production-full-time)" course, part of the [MSc in Business Analytics](https://economics.ceu.edu/program/master-science-business-analytics) at CEU.

Table of Contents
=================

* [Schedule](#schedule)
* [Week 3: Using R in the Cloud](#week-3-using-r-in-the-cloud)
    * [Welcome to AWS!](#welcome-to-aws)
    * [Getting access to EC2 boxes](#getting-access-to-ec2-boxes)
    * [Create and connect to an EC2 box](#create-and-connect-to-an-ec2-box)
    * [Install RStudio Server on EC2](#install-rstudio-server-on-ec2)
    * [Connect to the RStudio Server](#connect-to-the-rstudio-server)
    * [Set up an easy to remember domain name](#set-up-an-easy-to-remember-domain-name)
    * [Play with R for a bit](#play-with-r-for-a-bit)
    * [Schedule R scripts](#schedule-r-scripts)
    * [ScheduleR improvements](#scheduler-improvements)
    * [Job Scheduler exercises](#job-scheduler-exercises)
    * [First steps with interactive R-driven apps: Shiny](#first-steps-with-interactive-r-driven-apps-shiny)
    * [Shiny exercises](#shiny-exercises)
    * [Shiny Server](#shiny-server)
    * [Further exercises](#further-exercises)
    * [If in doubt](#if-in-doubt)

## Schedule

* 11:00 - 12:30 Session 1
* 12:30 - 13:30 Lunch
* 13:30 - 15:00 Session 2
* 15:00 - 15:30 Coffee break
* 15:30 - 17:00 Session 3

## Week 3: Using R in the Cloud

**Goal**: learn how to run and schedule R jobs and apps in the cloud.

### Welcome to AWS!

1. Use the central CEU AWS account: https://ceu.signin.aws.amazon.com/console
2. Set up 2FA: https://console.aws.amazon.com/iam
3. Secure your access keys:

    > "When I woke up the next morning, I had four emails and a missed phone call from Amazon AWS - something about 140 servers running on my AWS account, mining Bitcoin"
    -- [Hoffman said](https://www.theregister.co.uk/2015/01/06/dev_blunder_shows_github_crawling_with_keyslurping_bots)

    PS probably you do not really need to store any access keys, but you may rely on roles and KMS

4. Let's use the `eu-west-1` Ireland region

### Getting access to EC2 boxes

**Note**: we follow the instructions on Windows in the Computer Lab, but please find below how to access the boxes from Mac or Linux as well when working with the instances remotely.

1. Create (or import) an SSH key in AWS: https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName
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
    3. Pick the `Ubuntu Server 16.04 LTS (HVM), SSD Volume Type` AMI
    4. Pick `t2.micro` instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
    5. Click "Review and Launch"
    6. Pick a unique name for the security group
    7. Click "Launch"

2. Connect to the box

    1. Specify the hostname or IP address

    ![](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/images/vm-putty-1.png)

    2. Specify the key for authentication

    ![](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/images/vm-putty-2.png)

    3. Set the username to `ubuntu` on the Connection/Data tab
    4. Save the Session profile
    5. Click the "Open" button

### Install RStudio Server on EC2

1. Look at the docs: https://www.rstudio.com/products/rstudio/download-server
2. Download Ubuntu `apt` package list

        sudo apt update

3. Install dependencies

        sudo apt install r-base gdebi-core

4. Try R

        R

5. Install RStudio Server

        wget https://download2.rstudio.org/rstudio-server-1.1.423-amd64.deb
        sudo gdebi rstudio-server-1.1.423-amd64.deb

6. Check process and open ports

        sudo ps aux| grep rstudio
        sudo rstudio-server status
        sudo systemctl status rstudio-server
        sudo netstat -tapen|grep LIST

7. Look at the docs: http://docs.rstudio.com/ide/server-pro/

### Connect to the RStudio Server

1. Confirm that the service is up and running and the port is open

        ubuntu@ip-172-31-12-150:~$ sudo netstat -tapen|grep LIST
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
        install.packages('beanplot')
        system('whoami')

8. Reload webpage (F5)
9. Demo the terminal:

        $ sudo whoami
        ceu is not in the sudoers file.  This incident will be reported.

8. Grant sudo access to the new user:

        sudo apt install -y mc
        sudo mc
        sudo mcedit /etc/sudoers
        sudo adduser ceu admin
        man adduser
        man deluser

Note 1: might need to relogin
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

            sudo apt-get install r-cran-devtools r-cran-data.table r-cran-httr r-cran-futile.logger r-cran-jsonlite r-cran-data.table r-cran-snakecase

    2. Install an R package from GitHub to interact with crypto exchanges:

            devtools::install_github('daroczig/binancer')

    3. First steps with live data:

            library(binancer)
            klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60*3)
            str(klines)
            summary(klines$close)

    4. Visualize the data

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

    8. Create an R script that reports and/or plots on some cryptocurrencies

### Schedule R scripts

![](https://wiki.jenkins-ci.org/download/attachments/2916393/fire-jenkins.svg)

1. Install Jenkins from the RStudio/Terminal: https://pkg.jenkins.io/debian-stable/

        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
        echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list
        sudo apt update
        sudo apt install jenkins ## installs Java as well
        sudo netstat -tapen | grep java

2. Open up port 8080 in the related security group
3. Access Jenkins from your browser and finish installation

    1. Read the initial admin password from RStudio/Terminal via

            sudo cat /var/lib/jenkins/secrets/initialAdminPassword

    2. Proceed with installing the suggested plugins
    3. Create your first user (eg `ceu`)

4. Create a new job:

    1. Enter the name of the job: `get current Bitcoin price`
    2. Pick "Freestyle project"
    3. Click "OK"
    4. Add a new "Execute shell" build step
    5. Enter the below command to look up the most recent BTC price

            R -e "library(binancer);binance_coins_prices()[symbol == 'BTC', usd]"

    6. Run the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/jenkins-errors.png)

5. Install R packages system wide from RStudio/Terminal (more on this later):

        sudo Rscript -e "library(devtools);with_libpaths(new = '/usr/local/lib/R/site-library', install_github('daroczig/binancer'))"

6. Rerun the job

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/jenkins-success.png)

### ScheduleR improvements

1. Create an R script and run with `Rscript` instead of `R` -- eg with the below content

        library(binancer)
        prices <- binance_coins_prices()
        library(futile.logger)
        flog.info('The current Bitcoin price is: %s', [symbol == 'BTC', usd])

2. Learn about little R: https://github.com/eddelbuettel/littler
3. Set up e-mail notifications via SNS: https://eu-west-1.console.aws.amazon.com/ses/home?region=eu-west-1#

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

### Job Scheduler exercises

* Configure your first job to alert if Bitcoin price is below $10K or higher than $12K
* Create a Jenkins job running hourly to generate a candlestick chart on the price of BTC and ETH
* Create an alert if BTC or ETH price changed more than 5% in the past 24 hours

### First steps with interactive R-driven apps: Shiny

0. Install Shiny

        sudo apt-get install r-cran-shiny r-cran-rmarkdown

1. Refresh what we have ~learned~briefly covered in the DA1 class: https://github.com/daroczig/CEU-R-lab#week-6-100-min-introduction-to-r-markdown-and-shiny
2. Create a new "Shiny Web Application" file
3. Pick a name for the App and the "Single File" option
4. Copy/paste the content of our demo app from https://github.com/daroczig/CEU-R-lab/blob/2018/6.R
5. Click on the "Run app" button
6. Disable the popup blocker in the right corner of the navigation bar
7. Retry running the app and enjoy :)

### Shiny exercises

1. Create a minimal dashboard showing the ETH prices in the past 24 hours
2. Add a dropdown input field to the sidebar to let users change the interval of the plot (eg 1 min, 15 mins, 1 hour etc) -- read the `binance_klines` docs
3. Add a dropdown input field to the sidebar to let users pick the symbol (eg `ETH` or `BTC`)
4. Make the plot interactive eg with http://jkunst.com/highcharter

See the `shiny/highcharter` subfolder for a possible solution if you get stuck.

### Shiny Server

1. Install the `highcharter` package as a system user:

        sudo apt-get install r-cran-dplyr r-cran-quantmod r-cran-xml r-cran-tidyr r-cran-igraph r-cran-lubridate r-cran-psych r-cran-broom r-cran-yaml r-cran-htmlwidgets
        sudo R -e "devtools::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('highcharter', repos='https://cran.rstudio.com/'))"

2. Install Shiny Server:

        wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb
        sudo gdebi shiny-server-1.5.6.875-amd64.deb

3. Edit `site_dir` in `shiny-server.conf`:

        sudo mcedit /etc/shiny-server/shiny-server.conf
        sudo systemctl restart shiny-server

4. Visit Shiny Server on port 3838 from your browser

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/shiny-server.png)

5. Always keep logs -- set this in the Shiny Server config & restart service:

        preserve_logs true;

5. Debug logs

        ls -la /var/log/shiny-server

### Further exercises

* Look at the `forecast` package and make predictions on future Bitcoin prices -- visualize on a dashboard
* Look at the `knitr` or `pander` packages and schedule an HTML e-mail report including an image on the price changes -- refresh what we have ~learned~briefly covered in the DA1 class: https://github.com/daroczig/CEU-R-lab#week-6-100-min-introduction-to-r-markdown-and-shiny

### If in doubt

Kill your current box and start a new one using the `data-infra-in-prod-R-image` AMI that already bundles all above steps:

![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/custom-ami.png)

## Week 4: Use Cases on Using R in the Cloud

**Quiz**: no quiz today -- but please consider spending the related time later to fill in more details in the QA questionnaire on this class TODO

**Reminder**: what is
- RStudio Server
- Shiny Server
- Jenkins

### Stream processing with R

Background: [slides](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/AWR.Kinesis/AWR.Kinesis-talk.pdf)

#### Create a central RStudio server

We will use one decent sized node today instead of many tiny instances: `t2.xlarge` with 4 vCPU and 16 gigs of RAM

Use our custom Amazon AMI: `data-infra-in-prod-R-image`

Already installed software:

- RStudio Server
- Shiny Server
- Jenkins

Configured users: `ceu`

**Notes**: the `sudo` commands are to be run on only one computer as those updates will take effect globally, so

- run all steps if you are configuring the server
- run only the steps in R / you were asked to run if you are a regular user

#### Create a user for every member of the team

We'll export the list of IAM users from AWS and create a system user for everyone.

1. Attach a newly created IAM EC2 Role (let's call it `ceudataserver`) to the EC2 box and assign 'Read-only IAM access':

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-type.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-rights.png)

2. Install AWS CLI tool:

    ```
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

5. Create a new system user on the box (for RStudio Server access) for every IAM user:

   ```
   library(futile.logger)
   for (user in users[[1]]$UserName) {
     flog.info(sprintf('Creating %s', user))
     system(sprintf("sudo adduser --disabled-password --quiet --gecos '' %s", user))
     flog.info(sprintf('Setting password for %s', user))
     system(sprintf("echo '%s:secretpass' | sudo chpasswd", user)) ## note the single quotes + sudo
   }
   ```

Note, you may have to temporarily enable passwordless `sudo` for this user :/

```
ceu ALL=(ALL) NOPASSWD:ALL
```

Check users:

```
readLines('/etc/passwd')
```

#### Storing credentials and other secrets in a secure way in the cloud

Using Amazon's KMS: https://aws.amazon.com/kms

1. Go to IAM's Encryption Keys: https://console.aws.amazon.com/iam/home?region=eu-west-1#/encryptionKeys/us-east-1
2. Create a new key: `ceudata`
3. Optionally allow user access to the key
4. Allow the `ceudataserver` IAM role to use the key
5. Install `rJava`:

    ```
    sudo apt install r-cran-rjava
    ```

6. Install the `AWR.KMS` package globally:

    ```
    sudo R -e "devtools::with_libpaths(new = '/usr/local/lib/R/site-library', install.packages('AWR.KMS', repos='https://cran.rstudio.com/'))"
    ```

7. First steps with securing sensitive information

   ```r
   library(AWR.KMS)
   secret <- kms_encrypt('foobar', key = 'alias/ceudata')
   secret
   kms_decrypt(secret)
   ```



TODO create central R server with users from IAM set passwd to ceudata and permission to push to ECR (enough to demo)

TODO AWR.KMS example
TODO deploy app with Shiny (incl docker)

### Scheduling Jenkins jobs

#### Configure Jenkins to recognize the newly created Linux system users

1. Go to Manage Jenkins
2. Go to Configure Global Security
3. Enable "Unix user/group database" in the Security Realm
4. Add `jenkins` to the `shadow` group so that it can read the pass hashes

    ```
    sudo adduser jenkins shadow
    ```

5. Restart Jenkins

   ```
   sudo systemctl jenkins restart
   ```

#### Notes on creating new jobs

* Use your username as a prefix for all newly created jobs so that we can easily identify your jobs
* Let's create a view for every user
* All jobs are running as the `jenkins` user

#### More infra requirements

* Install Docker
* Enable Docker usage for `jenkins`

TODO Example Dockerfile

TODO docker build

TODO docker run from jenkins using an R package not installed

TODO create a Slack bot

TODO e-mail noti config using mailgun or something

### Scaling Shiny with Shinyproxy.io and Docker images

TODO survey on what was useful
