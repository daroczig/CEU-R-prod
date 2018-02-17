Here you can find the materials of 3rd and 4th week of the "[Data Infrastructure in Production](https://economics.ceu.edu/courses/data-infrastructure-production-full-time)" course, part of the [MSc in Business Analytics](https://economics.ceu.edu/program/master-science-business-analytics) at CEU.

## Schedule

* 11:00 - 12:30 Session 1
* 12:30 - 13:30 Lunch
* 13:30 - 15:00 Session 2
* 15:00 - 15:30 Coffee break
* 15:30 - 17:00 Session 3

## Week 3: Using R in the Cloud

**Goal**: learn how to run and schedule R jobs in the cloud.

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

    1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
    2. Click "Launch Instance"
    3. Pick the `Ubuntu Server 16.04 LTS (HVM), SSD Volume Type` AMI
    4. Pick `t2.micro` instance type
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

2. Try to connect to the host from a browser
3. Realize it's not working
4. Open up port 8787 in the security group

    ![](https://d2908q01vomqb2.cloudfront.net/b6692ea5df920cad691c20319a6fffd7a4a766b8/2017/10/12/r-update-1.gif)

5. Authentication: http://docs.rstudio.com/ide/server-pro/authenticating-users.html
6. Create a new user:

        sudo adduser rstudio-user

7. Login & quick demo:

        1+2
        plot(mtcars)
        install.packages('beanplot')
        system('whoami')

8. Reload webpage (F5)
9. Demo the terminal:

        $ sudo whoami
        rstudio-user is not in the sudoers file.  This incident will be reported.

8. Grant sudo access to the new user:

        sudo apt install mc
        sudo mc
        sudo mcedit /etc/sudoers
        sudo adduser rstudio-user admin
        man adduser
        man deluser

Note 1: might need to relogin
Note 2: you might want to add `NOPASSWD` to the `sudoers` file:

        rstudio-user ALL=(ALL) NOPASSWD:ALL

Although also note (3) the related security risks.

9. Custom login page: http://docs.rstudio.com/ide/server-pro/authenticating-users.html#customizing-the-sign-in-page
10. Custom port: http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

### Set up an easy to remember domain name

1. Go to Route 53: https://console.aws.amazon.com/route53/home
2. Go to Hosted Zones and click on ceudata.net
3. Create a new Record, where

    - fill in the desired `Name` (subdomain)
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create`

### Play with R for a bit

1. Installing packages:

        install.packages('ggplot2')

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

            sudo apt-get install r-cran-devtools r-cran-data.table r-cran-httr r-cran-futile.logger r-cran-jsonlite

    2. Install an R package from GitHub to interact with a crypto exchange:

            devtools::install_github('daroczig/binancer')

    3. First steps with live data:

            library(binancer)
            klines <- get_klines('BTCUSDT', interval = '1m', limit = 60*3)
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
                get_klines,
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
