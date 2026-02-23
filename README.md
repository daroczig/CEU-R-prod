Here you can find the materials for the "[Data Engineering 3: Orchestration and Real-time Data Processing](https://ceu.studyguide.timeedit.net/modules/ECBS5211?type=CORE)" course, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous editions, see [2017/2018](https://github.com/daroczig/CEU-R-prod/tree/2017-2018), [2018/2019](https://github.com/daroczig/CEU-R-prod/tree/2018-2019), [2019/2020](https://github.com/daroczig/CEU-R-prod/tree/2019-2020), [2020/2021](https://github.com/daroczig/CEU-R-prod/tree/2020-2021), [2021/2022](https://github.com/daroczig/CEU-R-prod/tree/2021-2022), [2022/2023](https://github.com/daroczig/CEU-R-prod/tree/2022-2023), [2023/2024](https://github.com/daroczig/CEU-R-prod/tree/2023-2024), and [2024/2025](https://github.com/daroczig/CEU-R-prod/tree/2024-2025).

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Schedule](#schedule)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class Schedule](#class-schedule)

* [Home assignment](#home-assignment)
* [Getting help](#getting-help)

## Schedule

2 x 3 x 100 mins on Feb 16 and 23:

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
3. Join the Teams channel dedicated to the class at `CEU BA DE3 Batch Jobs and APIs ('25/26)` with the `c1vc62r` team code.
4. When joining remotely, it's highly suggested to get a second monitor where you can follow the online stream, and keep your main monitor for your own work. The second monitor could be an external screen attached to your laptop, e.g. a TV, monitor, projector, but if you don't have access to one, you may also use a tablet or phone to dial-in to the Zoom call.

## Class Schedule

To be updated weekly.

## Week 1

**Goal**: learn how to run and schedule Python or R jobs in the cloud.

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

### Getting access to EC2 boxes

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
    4. Pick the `Ubuntu Server 24.04 LTS (HVM), SSD Volume Type` AMI
    5. Pick `t3a.small` (2 GiB of RAM should be enough for most tasks) instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
    6. Select your AWS key created above and launch
    7. Update the volume size to 20 GiB to make sure we have enough space.
    8. Pick a unique name for the security group after clicking "Edit" on the "Network settings"
    9. Click "Launch instance"
    10. Note and click on the instance id

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
ssh -i /path/to/your/pem ubuntu@ip-address-of-your-machine
```

As a last resort, use "EC2 Instance Connect" from the EC2 dashboard by clicking "Connect" in the context menu of the instance (triggered by right click in the table).

### Install RStudio Server on EC2

Yes, although most of you are using Python, we will install RStudio Server (with
support for both R and Python), as it comes with a lot of useful features for
the coming hours at this class (e.g. it's most complete and production-ready open-source IDE supporting multiple users and languages).

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
    # any ideas what this command does?
    hist(runif(100))
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

    Note, if you have X11 server installed, you can forward X11 through SSH to
    render locally, but this can be complicated to set up on a random operating
    system, and also not very convenient, so we will not bother with it for now.

5. Try this in Python as well!

    ```sh
    $ python
    Command 'python' not found, did you mean:
      command 'python3' from deb python3
      command 'python' from deb python-is-python3

    $ python3 --version
    Python 3.12.3
    ```

    Let's symlink `python` to `python3` to make it easier to use:

    ```sh
    sudo apt install python-is-python3
    ```

    And install `matplotlib`:

    ```sh
    sudo apt install python3-matplotlib
    ```

    Then replicate that histogram:

    ```python
    import matplotlib.pyplot as plt
    import random

    numbers = [random.random() for _ in range(100)]
    plt.hist(numbers)
    plt.show()
    ```

    But uh oh, there's no plot!

    ```python
    plt.savefig("python.png")
    ```

5. Install RStudio Server

    ```sh
    wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2026.01.0-392-amd64.deb
    sudo apt install -y gdebi-core
    sudo gdebi rstudio-server-2026.01.0-392-amd64.deb
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
    ubuntu@ip-172-31-12-150:~$ sudo ss -tapen | grep LIST
    tcp        0      0 0.0.0.0:8787            0.0.0.0:*               LISTEN      0          49065       23587/rserver
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          15671       1305/sshd
    tcp6       0      0 :::22                   :::*                    LISTEN      0          15673       1305/sshd
    ```

2. Try to connect to the host from a browser on port 8787, eg http://foobar.eu-west-1.compute.amazonaws.com:8787
3. Realize it's not working
4. Open up port 8787 in the security group, by selecting your security group and click "Edit inbound rules":

    ![](https://user-images.githubusercontent.com/495736/222724348-869d0703-05f2-4ef3-bd80-574362e73265.png)

Now you should be able to access the service. If not, e.g. blocked by company firewall, don't worry, we can workaround that by using a proxy server -- to be set up in the next section.

### Set up an easy to remember IP address

Optionally you can associate a fixed IP address to your box, so that the IP address is not changing when you stop and start the box.

1. Allocate a new Elastic IP address at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Addresses:
2. Name this resource by assigning the "Name" and "Owner" tags
3. Associate this Elastic IP with your stopped box, then start it

### Set up an easy to remember domain name

Optionally you can associate a subdomain with your node, using the above created Elastic IP address:

1. Go to Route 53: https://console.aws.amazon.com/route53/home
2. Go to Hosted Zones and click on `de3.click`
3. Create a new `A` record:

    - fill in the desired `Record name` (subdomain), eg `foobar` (well, use your own username as the subdomain)
    - paste the public IP address or hostname of your server in the `Value` field
    - click `Create records`

4. Now you will be able to access your box using this custom (sub)domain, no need to remember IP addresses.

### Configuring for standard ports

To avoid using ports like `8787` and `8080` (and get blocked by the firewall installed on the CEU WiFi), let's configure our services to listen on the standard 80 (HTTP) and potentially on the 443 (HTTPS) port as well, and serve RStudio on the `/rstudio`, and later Jenkins on the `/jenkins` path.

For this end, we will use Caddy as a reverse-proxy, so let's install it first:

```shell
sudo apt install -y caddy
```

Then let's edit the main configuration file `/etc/caddy/Caddyfile`, which also do some transformations, eg rewriting the URL (removing the `/rstudio` path) before hitting RStudio Server. To edit the file, we can use the `nano` editor:

```shell
sudo nano /etc/caddy/Caddyfile
```

If you are not familiar with the `nano` editor, check the keyboard shortcuts at
the bottom of the screen, e.g. `^X` (Ctrl+X keys pressed simultaneously) to
exit, or `M-A` (Alt+A keys pressed simultaneously) to start marking text for
later copying or deleting.

Delete everything (either by patiently pressing the `Delete` or `Backspace`
keys, or by pressing `M-A`, then navigating to the bottom of the file and
pressing `^K`), and copy/paste (Shift+Insert or Ctrl+Shift+C) the following
content:

```
:80 {
    redir /rstudio /rstudio/ permanent
    handle_path /rstudio/* {
        reverse_proxy localhost:8787 {
            transport http {
                read_timeout 20d
            }
            # need to rewrite the Location header to remove the port number
            # https://caddy.community/t/reverse-proxy-header-down-on-location-header-or-something-equivalent/13157/3
            header_down  Location ([^:]+://[^:]+(:[0-9]+)?/)  ./
        }
    }
}
```

And restart the Caddy service:

```shell
sudo systemctl restart caddy
```

Find more information at https://support.rstudio.com/hc/en-us/articles/200552326-Running-RStudio-Server-with-a-Proxy.

Let's see if the port is open on the machine:

```shell
sudo ss -tapen|grep LIST
```

Let's see if we can access RStudio Server on the new path:

```shell
curl localhost/rstudio
```

Now let's see from the outside world ... and realize that we need to open up port 80!

Now we need to tweak the config to support other services as well in the future e.g. Jenkins:

```
:80 {
    redir /rstudio /rstudio/ permanent
    handle_path /rstudio/* {
        reverse_proxy localhost:8787 {
            transport http {
                read_timeout 20d
            }
            # need to rewrite the Location header to remove the port number
            # https://caddy.community/t/reverse-proxy-header-down-on-location-header-or-something-equivalent/13157/3
            header_down  Location ([^:]+://[^:]+(:[0-9]+)?/)  ./
        }
    }

    handle /jenkins/* {
        reverse_proxy 127.0.0.1:8080
    }
}
```

It might be useful to also proxy port 8000 for future use via updating the Caddy config to:

```
:80 {
    redir /rstudio /rstudio/ permanent
    handle_path /rstudio/* {
        reverse_proxy localhost:8787 {
            transport http {
                read_timeout 20d
            }
            # need to rewrite the Location header to remove the port number
            # https://caddy.community/t/reverse-proxy-header-down-on-location-header-or-something-equivalent/13157/3
            header_down  Location ([^:]+://[^:]+(:[0-9]+)?/)  ./
        }
    }

    handle /jenkins/* {
        reverse_proxy 127.0.0.1:8080
    }

    handle_path /8000/* {
        reverse_proxy 127.0.0.1:8000
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

If you cannot access RStudio Server on port 80, you might need to restart `caddy` as per above.

It's useful to note that above paths in the index page as a reminder, that you can achive by adding the following to the Caddy configuration:

```
handle / {
    respond "Welcome to DE3! Are you looking for /rstudio or /jenkins?" 200
}
```

Next, you might really want to set up SSL either with Caddy or placing an AWS
Load Balancer in front of the EC2 node. For a simple setup, we can realy on
Caddy's built-in SSL support using LetsEncrypt:

1. Register a domain name (or use the already registered `de3.click` domain
   subdomain), and point it to your EC2 node's public IP address:
   https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones
2. You might need to wait a bit for the DNS to propagate. Check via `dig` or similar, e.g.:

    ```
    dig foobar.de3.click
    ```

3. Update the Caddy configuration to use the new domain name instead of `:80` in
   `/etc/caddy/Caddyfile`:

    ```
    foobar.de3.click {
        redir /rstudio /rstudio/ permanent
        handle_path /rstudio/* {
            reverse_proxy localhost:8787 {
                transport http {
                    read_timeout 20d
                }
                # need to rewrite the Location header to remove the port number
                # https://caddy.community/t/reverse-proxy-header-down-on-location-header-or-something-equivalent/13157/3
                header_down  Location ([^:]+://[^:]+(:[0-9]+)?/)  ./
            }
        }

        handle /jenkins/* {
            reverse_proxy 127.0.0.1:8080
        }

        handle_path /8000/* {
            reverse_proxy 127.0.0.1:8000
        }

        handle / {
            respond "Welcome to DE3! Are you looking for /rstudio or /jenkins?" 200
        }
    }
    ```

4. Caddy will then automatically obtain and renew the SSL certificate using
   LetsEncrypt, and you will be able to access the services via the new domain
   name through HTTPS. If you are interested in the related logs, you can view
   them in the Caddy logs:

    ```shell
    sudo journalctl -u caddy
    # follow logs
    sudo journalctl -u caddy
    ```

### Connect again to the RStudio Server

1. Authentication: http://docs.rstudio.com/ide/server-pro/authenticating-users.html
2. Create a new user:

    ```shell
    sudo adduser foobar
    ```

3. Login & quick demo:

    ```r
    1+2
    plot(runif(100))
    install.packages('fortunes')
    library(fortunes)
    fortune()
    fortune(200)
    system('whoami')
    ```

4. Reload webpage (F5), realize we continue where we left the browser :)

5. Create a Python script and try to run it (in class: don't run it yet, just pay attention to the shared screen):

    ```python
    import matplotlib.pyplot as plt
    import random

    numbers = [random.random() for _ in range(100)]
    plt.hist(numbers)
    plt.show()
    ```

    Note that RStudio Server will ask you to confirm the installation of a few
    packages ... which takes ages (compiling C++ etc), so we better install the
    binary packages instead:

    ```sh
    sudo apt install --no-install-recommends \
      r-cran-jsonlite r-cran-reticulate r-cran-png
    ```

    Now return to the Python script. But we still cannot run it, as the
    `matplotlib` package is not installed. Strange, we just installed it in the
    shell! To understand what's happening, get back to R and check the Python
    interpreter:

    ```r
    reticulate::py_config()
    reticulate::py_require("matplotlib")
    ```

    Note that this is a temporary virtual environment, so you need to install
    the packages again if you restart the R session.

    Now the script runs .. until you restart the R session.

    So let's create a persistent virtual environment for Python and install the
    packages there:

    ```r
    library(reticulate)
    virtualenv_create("de3")
    virtualenv_install("de3", packages = c("matplotlib"))
    use_virtualenv("de3", required = TRUE)
    ```

    Note that creating the virtual environment failed due to some missing OS dependencies (e.g. `pip`),
    so let's install them first in the shell:

    ```sh
    sudo apt install python3-venv python3-pip python3-dev
    ```

    Then run the following commands in R, and then try to rerun the Python
    script as well. You might need to restart R and go to the `Tools` menu /
    `Global Options` / `Python` / `Use Virtual Environment` and select the `de3`
    environment.

    Now return to the Python script again, and rerun your script.

6. Annoyed already with switching between R and Python? And then switching to
    SSH? Let's try to simplify that by using the built-in terminal in RStudio:

    ```console
    $ whoami
    ceu
    $ sudo whoami
    ceu is not in the sudoers file.  This incident will be reported.
    ```

7. Grant sudo access to the new user by going back to SSH with `root` access:

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

8. Custom login page: http://docs.rstudio.com/ide/server-pro/authenticating-users.html#customizing-the-sign-in-page
9. Custom port (e.g. 80): http://docs.rstudio.com/ide/server-pro/access-and-security.html#network-port-and-address

    ```sh
    echo "www-port=80" | sudo tee -a /etc/rstudio/rserver.conf
    sudo rstudio-server restart

### Python playground

Great, we have a working environment for R and Python.
Now let's try to do something useful with it!

Create a Python or R script to get the most recent Bitcoin <> USD prices (e.g.
from the Binance API), report the last price and the price change in the last 1
hour, and plot a line chart of the price history, something like:

```
BTC current price is $42,000, with a standard deviation of 100.
```

![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-1.png)

```py
from binance.client import Client
client = Client()

# https://python-binance.readthedocs.io/en/latest/binance.html#binance.client.Client.get_klines
klines = client.get_klines(symbol='BTCUSDT', interval='1m', limit=60)

# report on closing prices
close = [float(d[4]) for d in klines]

from statistics import stdev
print(f"BTC current price is ${close[-1]}, with a standard deviation of {round(stdev(close), 2)}.")

# create a line chart of the price history
from datetime import datetime
dates = [datetime.fromtimestamp(k[0] / 1000) for k in klines]

import matplotlib.pyplot as plt
plt.clf()
plt.plot(dates, close, marker='o')
plt.title('BTC Price History')
plt.show()

# save the plot to a file
plt.savefig('btc_price_history.png')
```

To demo how it would be implemented in R, let's install some related packages:

```sh
sudo apt install --no-install-recommends \
  r-cran-ggplot2 r-cran-glue r-cran-remotes \
  r-cran-data.table r-cran-httr r-cran-digest r-cran-logger r-cran-jsonlite r-cran-snakecase
```

Then in an R package from GitHub:

```r
library(remotes)
install_github("daroczig/binancer")
```

And the actual R code:

```r
library(binancer)
klines <- binance_klines('BTCUSDT', interval = '1m', limit = 60)
library(glue)
print(glue("BTC current price is ${klines$close[60]}, with a standard deviation of {round(sd(klines$close), 2)}."))

library(ggplot2)
ggplot(klines, aes(close_time, close)) + geom_line()
```

Great! Now let's create a candlestick chart of the price history, something like:

![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-2.png)

```python
from binance.client import Client
client = Client()
klines = client.get_klines(symbol='BTCUSDT', interval='1m', limit=60)

# reticulate::py_install("pandas")
import pandas as pd
df = pd.DataFrame(klines, columns=[
    'timestamp', 'open', 'high', 'low', 'close', 'volume',
    'close_time', 'quote_volume', 'trades', 'taker_buy_base',
    'taker_buy_quote', 'ignore'
])

df['timestamp'] = pd.to_datetime(df['timestamp'], unit='ms')
df[['open', 'high', 'low', 'close', 'volume']] = df[['open', 'high', 'low', 'close', 'volume']].astype(float)

# reticulate::py_install("mplfinance")
import mplfinance as mpf

df_plot = df.set_index('timestamp')
df_plot = df_plot[['open', 'high', 'low', 'close', 'volume']]

mpf.plot(df_plot, type='candle', style='charles',
         title='BTC Price History',
         ylabel='Price (USD)')
```

Or via `matplotlib`:

```python
from matplotlib.patches import Rectangle

fig, ax = plt.subplots(figsize=(12, 6))

for i, row in df.iterrows():
    color = 'green' if row['close'] >= row['open'] else 'red'

    # candle lines for high/low
    ax.plot([i, i], [row['low'], row['high']], color=color, linewidth=1)

    # candle body for open/close
    height = abs(row['close'] - row['open'])
    bottom = min(row['open'], row['close'])
    rect = Rectangle((i - 0.3, bottom), 0.6, height, facecolor=color, edgecolor=color, alpha=0.8)
    ax.add_patch(rect)

ax.set_title('BTC Price History')
plt.show()
```

Same in R:

```r
ggplot(klines, aes(open_time)) +
    geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
    geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
    theme_bw() + theme('legend.position' = 'none') + xlab('') +
```

Or a bit more polished version:

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

For the record, doing the same for 4 symbols would be also as simple as:

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

![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-3.png)


### Install Jenkins to schedule R or Python commands

![](https://wiki.jenkins-ci.org/download/attachments/2916393/fire-jenkins.svg)

1. Install Jenkins from the RStudio/Terminal:
   <https://www.jenkins.io/doc/book/installing/linux/#debianubuntu>

    ```sh
    sudo apt install -y fontconfig openjdk-21-jre

    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y jenkins

    # check which port is open by java (jenkins)
    sudo ss -tapen | grep java
    ```

2. Open up port `8080` in the related security group if you want direct access
3. To make use of the Caddy proxy, we need to update the Jenkins configuration
   to use the `/jenkins` path: uncomment `Environment="JENKINS_PREFIX=/jenkins"`
   in `/lib/systemd/system/jenkins.service`, then reload the Systemd configs and
   restart Jenkins:

    ```shell
    sudo systemctl daemon-reload
    sudo systemctl restart jenkins
    ```

    You can find more details at the [Jenkins reverse proxy guide](https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-with-jenkins/reverse-proxy-configuration-nginx/) and [troubleshooting guide](https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-troubleshooting/).

4. Access Jenkins from your browser and finish installation

    1. Read the initial admin password from RStudio/Terminal via

        ```sh
        sudo cat /var/lib/jenkins/secrets/initialAdminPassword
        ```

    2. Proceed with installing the suggested plugins
    3. Create your first user (eg `ceu`)

Note that if loading Jenkins after getting a new IP takes a lot of time, it might be due to
not be able to load the `theme.css` as trying to search for that on the previous IP (as per
Jenkins URL setting). To overcome this, wait 2 mins for the `theme.css` timeout, login, disable
the dark theme plugin at the `/jenkins/manage/pluginManager/installed` path, and then restart Jenkins at the bottom of the page via `Restart` button. Find more details at <https://github.com/jenkinsci/dark-theme-plugin/issues/458>.

### Schedule R or Python commands

Let's schedule a Jenkins job to check on the Bitcoin prices every hour!

1. Create a "New Item" (job) in Jenkins:

    1. Enter the name of the job: `get current Bitcoin price`
    2. Pick "Freestyle project"
    3. Click "OK"
    4. Add a new "Execute shell" build step
    5. Enter the below command to use the previously written Python script to look up the most recent BTC price

        ```sh
        python3 /home/<USERNAME>/<FILENAME>.py
        ```

    6. Run the job

        ![](https://i.ibb.co/MyJ2Ww9d/image.png)

2. Debug & figure out what's the problem: it's a permission error, so let's add
   the `jenkins` user to the `<USERNAME>` group:

    ```shell
    sudo adduser jenkins <USERNAME>
    ```

    Then restart Jenkins from the RStudio Server terminal:

    ```shell
    sudo systemctl restart jenkins
    ```

    A better solution will be later to commit our Python or R script into a git
    repo, and make it part of the job to update from the repo .. or even better,
    use Docker to run the job in a container.

3. Yay, another error:

    ![](https://i.ibb.co/p6KCp3QN/image.png)

    This is due to not finding the virtual environment, so let's add that to our build step:

    ```shell
    . /home/<USERNAME>/.virtualenvs/de3/bin/activate
    ```

    Note the leading dot `.` in the command, which is a special character in the
    shell -- a shorthand for `source` command to set environment variables. As
    Jenkins by default runs the commands in `sh` (and not e.g. Bourne shell
    `bash`), we need to use the `.` shorthand.

4. It runs at last:

    ![](https://i.ibb.co/KnyNr44/image.png)

5. Now let's update our code to generate a line plot and store in the workspace:

    ```python
    from binance.client import Client

    client = Client()
    klines = client.get_klines(symbol='BTCUSDT', interval='1m', limit=60)
    close = [float(d[4]) for d in klines]

    from statistics import stdev
    print(f"BTC current price is ${close[-1]}, with a standard deviation of {round(stdev(close), 2)}.")

    # create a line chart of the price history
    from datetime import datetime
    dates = [datetime.fromtimestamp(k[0] / 1000) for k in klines]

    import matplotlib.pyplot as plt
    plt.clf()
    plt.plot(dates, close, marker='o')
    plt.title('BTC Price History')
    plt.savefig("btcprice.png")
    ```

6. Then find the Workspace of the Project, such as <https://daroczig.de3.click/jenkins/job/t/ws/btcprice.png>. Note that this image will be updated every run.


### Install VS Code "Server"

If you are not happy with RStudio Server, you can also install "VS Code in the
browser" from <https://github.com/coder/code-server>:

1. Check the source of their install script: <https://code-server.dev/install.sh>
2. Test the install script:

    ```
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
    ```
3. Install the code-server package:

    ```
    curl -fsSL https://code-server.dev/install.sh | sh
    ```
4. Start the code-server service for a **given user** (an emphasis here to run this as a user):

    ```
    sudo systemctl restart code-server@<USERNAME>
    ```

Note that the service will be started for the given user, so there's no
multi-user access like in RStudio Server, and it runs on port `8080` by default.

Let's update the port number to something special (to avoid later port number
conflicts) and configure Caddy to proxy it:

1. Edit (e.g. using `nano`) the `~/.config/code-server/config.yaml` file to set
   the port number to 8888
2. Take a note of the password from the config file, as you will need it to
   login to the service.
3. Restart the code-server service:

    ```
    sudo systemctl restart code-server@<USERNAME>
    ```

4. Update the Caddy configuration to proxy the new port:

    ```
    handle /coder/* {
        reverse_proxy 127.0.0.1:8888
        uri strip_prefix /coder
    }
    ```

5. Restart the Caddy service:

    ```
    sudo systemctl restart caddy
    ```

6. You can now access the code-server service via the browser at
   `https://<USERNAME>.de3.click/coder`.
7. Install the Python extension or anything else you need :)

### Why we did all this?

In short, it was meant to be a hand-on session to demonstrate and get a feel for setting up cloud infrastructure manually. You might like it it and decide to learn/do more, or you might prefer not dealing with infrastruture ever again -- which is fine.

Hosnestly, the actual programmin environment (e.g. Python or R) and the environment (e.g. Jenkins, Airflow, etc.) do not really matter that much -- the tools were chosen to have a defined number of moving pieces and make sure we understand how those play together.

Today we used:

- EC Instance Connect instead of SSH to connect to our virtual machine to overcome the firewall limitations,
- `apt` package manager to install software,
- RStudio Server as the main control interface for R, Python, and the terminal as well,
- Jenkins to schedule R or Python commands to run on a regular basis,
- Caddy as a reverse proxy to access the services via a human-friendly domain name and HTTPS.



## Week 2

Quiz: https://forms.office.com/e/wRAxGqirdV (5 mins to convince me -- using your own words -- that you understand the concepts)

### Recap on Week 1

1. 2FA/MFA in AWS
2. Creating EC2 nodes
3. Connecting to EC2 nodes via SSH/Putty or EC2 Instance Connect
4. Updating security groups
5. Installing RStudio Server
6. Setting up a reserved proxy along with a domain name and SSL certificate
7. The difference between R console and Shell
8. The use of `sudo` and how to grant `root` (system administrator) privileges
9. Adding new Linux users, setting password, adding to group
10. Installing Python packages within RStudio Server and in a virtual environment
11. Installing Jenkins
12. Scheduling basic commands on Jenkins
13. Installing VS Code "Server"


Note that you do NOT need to do the instructions below marked with the 💪 emoji -- those have been already done for you, and the related steps are only included below for documenting what has been done and demonstrated in the class.

### Amazon Machine Images

💪 Instead of starting from scratch, let's create an Amazon Machine Image (AMI) from the EC2 node we used last week, so that we can use that as the basis of all the next steps:

* Find the EC2 node in the EC2 console
* Right click, then "Image and templates" / "Create image"
* Name the AMI and click "Create image"
* It might take a few minutes to finish

Then you can use the newly created `de3-week2` AMI to spin up a new instance for you:

1. Go the the Instances overview at https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId
2. Click "Launch Instance"
3. Provide a name for your server (e.g. `daroczig-de3-week2`) and some additional tags for resource tracking, including tagging downstream services, such as Instance and Volumes:

    * Class: `DE3`
    * Owner: `daroczig`
    * subdomain: `daroczig` -- **NOTE** that this is important for the next step! The startup script will register this subdomain under the `count-down-timer.eu.org` domain name so that you can access RStudio Server, Jenkins, etc from your browser without fighting with firewall rules.

4. Pick the `de3-week2` AMI
5. Pick `t3a.medium` (4 GiB of RAM should be enough for most tasks) instance type (see more [instance types](https://aws.amazon.com/ec2/instance-types))
6. Select your AWS key created above and launch
7. Select the `de3` security group (granting access to ports 22, 443, 8000, 8080, and 8787)
8. Click "Advanced details" and select `ceudataserver` IAM instance profile, which grants permissions to read EC2 tags and update Route53 records and a few other services that are required in some later steps.
10. Note and click on the instance id

### 💪 Startup script to register subdomain and configure Caddy

We need a script that:

1. Reads the subdomain from the EC2 tags
2. Looks up the hosted zone ID for the domain name
3. Updates the Route53 record to point to the EC2 instance's public IP address
4. Configures Caddy to proxy the requests to the EC2 instance's ports

Note that this script requires the AWS CLI to be installed and configured with
the appropriate permissions. The AWS CLI was installed via:

```sh
sudo snap install aws-cli --classic
```

And the required permissions were granted via the `ceudataserver` IAM instance profile,
including read-only access to EC2 tags and write permissions on Route53 records.

```sh
#!/usr/bin/env bash
set -euo pipefail

DOMAIN_NAME="count-down-timer.eu.org"

# look up info on the EC2 instance using the EC2 metadata endpoint
META=http://169.254.169.254/latest
TOKEN=$(curl -s -X PUT "$META/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
get_metadata () {
  curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    "$META/meta-data/$1"
}
INSTANCE_ID=$(get_metadata instance-id)
REGION=$(get_metadata placement/region)

# hit a bump querying the tag from the metadata server, so let's use the AWS CLI instead
SUBDOMAIN=$(aws ec2 describe-tags \
  --region "$REGION" \
  --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=subdomain" \
  --query "Tags[0].Value" \
  --output text)
if [ "$SUBDOMAIN" == "None" ] || [ -z "$SUBDOMAIN" ]; then
  echo "ERROR: 'subdomain' tag not found on instance $INSTANCE_ID"
  exit 1
fi
DOMAIN="${SUBDOMAIN}.${DOMAIN_NAME}"

# update Route53 record
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name "${DOMAIN_NAME}" \
  --query "HostedZones[0].Id" \
  --output text | cut -d'/' -f3)
echo "Hosted Zone ID: $HOSTED_ZONE_ID"
PUBLIC_IP=$(get_metadata public-ipv4)
echo "Public IP: $PUBLIC_IP"
cat > /tmp/route53-change.json <<EOF
{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "$DOMAIN",
      "Type": "A",
      "TTL": 300,
      "ResourceRecords": [{"Value": "$PUBLIC_IP"}]
    }
  }]
}
EOF
echo "Updating Route53 record..."
aws route53 change-resource-record-sets \
  --hosted-zone-id "$HOSTED_ZONE_ID" \
  --change-batch file:///tmp/route53-change.json
rm /tmp/route53-change.json

# configure caddy
mkdir -p /etc/caddy
cat <<EOF >/etc/caddy/Caddyfile
$DOMAIN {
    redir /rstudio /rstudio/ permanent
    handle_path /rstudio/* {
        reverse_proxy localhost:8787 {
            transport http {
                read_timeout 20d
            }
            header_down Location ([^:]+://[^:]+(:[0-9]+)?/)  ./
        }
    }

    handle /jenkins/* {
        reverse_proxy 127.0.0.1:8080
    }

    handle_path /8000/* {
        reverse_proxy 127.0.0.1:8000
    }

    handle / {
        respond "Welcome to DE3! Are you looking for /rstudio or /jenkins?" 200
    }

    encode gzip

    log {
        output file /var/log/caddy/access.log
        format json
    }
}
EOF
```

We need to make that script executable:

```sh
sudo chmod +x /usr/local/bin/update-caddy-domain.sh
```

Create a systemd service at `/etc/systemd/system/caddy-setup.service`
to run the script at startup before Caddy starts:

```sh
[Unit]
Description=Update Route53 and Caddy config before Caddy starts
Before=caddy.service
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update-caddy-domain.sh
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and test the service:

```sh
sudo systemctl daemon-reload
sudo systemctl enable caddy-setup.service
sudo systemctl start caddy-setup.service
```

Profit 💸

In case profit does not happen .. a few hints for debugging after booting the instance:

```shell
# check the service status and
systemctl status caddy-setup.service
journalctl -u caddy-setup.service -n 100 -f

# try to run the script manually
/usr/local/bin/update-caddy-domain.sh
```

### 💪 Create a user for every member of the team

We'll export the list of IAM users from AWS and create a system user for everyone.

1. Attach a newly created IAM EC2 Role (let's call it `ceudataserver`) to the EC2 box and assign 'Read-only IAM access' (`IAMReadOnlyAccess`):

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-type.png)

    ![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/master/images/ec2-new-role-rights.png)

2. Install AWS CLI tool (note that using the snap package manager as it was removed from the apt repos):

    ```
    sudo snap install aws-cli --classic
    ```

3. List all the IAM users: https://docs.aws.amazon.com/cli/latest/reference/iam/list-users.html

   ```
   aws iam list-users
   ```

4. Install R packages from JSON parsing and logging (in the next steps) from the apt repo instead of CRAN sources as per https://github.com/eddelbuettel/r2u

    ```sh
    wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | sudo tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc
    sudo add-apt-repository "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu noble main"
    sudo apt update

    sudo apt install --no-install-recommends r-cran-jsonlite r-cran-logger r-cran-glue
    ```

    Note that all dependencies (let it be an R package or system/Ubuntu package) have been automatically resolved and installed.

    Don't forget to click on the brush icon to clean up your terminal output if needed.

    Optionally [enable `bspm`](https://github.com/eddelbuettel/r2u#step-5-use-bspm-optional) to enable binary package installations via the traditional `install.packages` R function.

5. Export the list of users from R:

    ```r
    library(jsonlite)
    users <- fromJSON(system('aws iam list-users', intern = TRUE))
    str(users)
    users[[1]]$UserName
    ```

    Or Python:

    ```python
    import boto3

    iam = boto3.client('iam')
    response = iam.list_users()
    users = response['Users']

    users[0]
    users[0]["UserName"]
    ```

6. Create a new system user on the box (for RStudio Server access) for every IAM user, set password and add to group:

    ```r
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

        log_info('Adding {user} to jenkins group')
        system(glue('sudo adduser {user} jenkins'))

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

1. Install the "PAM Authentication Plugin" in Jenkins.
2. Enable Jenkins to use PAM authentication by adding to the `shadow` group, then restart Jenkins:

    ```sh
    sudo adduser jenkins shadow
    sudo systemctl restart jenkins
    ```

3. Update the security backend to use real Unix users for shared access (if users already created):

![](https://user-images.githubusercontent.com/495736/224517493-652ac34e-f44d-4ac9-8d04-d661dcfc4c4b.png)

Then make sure to test new user access in an incognito window to avoid closing yourself out :)

### Warmup exercises

Replicate the below plot either in R or Python! Feel free to use your notes from
last week, or scroll up in this `README.md` file for the actual code, and how to
install the required R or Python packages.

**Please do NOT try to hammer the server with AI recommendations on how to fix
things when things go wrong -- you are operating on a cloud server, not your
local machine, and you could do serious harm to this high-value production
server (and the billing account associated with the AWS account)!** 😊

![](https://raw.githubusercontent.com/daroczig/CEU-R-prod/2019-2020/images/binancer-plot-2.png)

Example solution in Python:

1. Install the required Python packages (in the R console):

    ```r
    reticulate::py_install(c('pandas', 'matplotlib', "python-binance"))
    ```

2. Create a Python script to replicate the plot:

    ```python
    from binance.client import Client
    client = Client()

    # https://python-binance.readthedocs.io/en/latest/binance.html#binance.client.Client.get_klines
    klines = client.get_klines(symbol='BTCUSDT', interval='1m', limit=60)

    # report on closing prices
    close = [float(d[4]) for d in klines]

    from statistics import stdev
    print(f"BTC current price is ${close[-1]}, with a standard deviation of {round(stdev(close), 2)}.")

    # create a line chart of the price history
    from datetime import datetime
    dates = [datetime.fromtimestamp(k[0] / 1000) for k in klines]

    import matplotlib.pyplot as plt
    plt.clf()
    plt.plot(dates, close, marker='o')
    plt.title('BTC Price History')
    #plt.show()
    plt.savefig('btc_price_history_linechart.png')


    import pandas as pd
    df = pd.DataFrame(klines, columns=[
        'timestamp', 'open', 'high', 'low', 'close', 'volume',
        'close_time', 'quote_volume', 'trades', 'taker_buy_base',
        'taker_buy_quote', 'ignore'
    ])
    df['timestamp'] = pd.to_datetime(df['timestamp'], unit='ms')
    df[['open', 'high', 'low', 'close', 'volume']] = df[['open', 'high', 'low', 'close', 'volume']].astype(float)

    from matplotlib.patches import Rectangle
    fig, ax = plt.subplots(figsize=(12, 6))
    for i, row in df.iterrows():
        color = 'green' if row['close'] >= row['open'] else 'red'
        # candle lines for high/low
        ax.plot([i, i], [row['low'], row['high']], color=color, linewidth=1)
        # candle body for open/close
        height = abs(row['close'] - row['open'])
        bottom = min(row['open'], row['close'])
        rect = Rectangle((i - 0.3, bottom), 0.6, height, facecolor=color, edgecolor=color, alpha=0.8)
        ax.add_patch(rect)
    ax.set_title('BTC Price History')
    # plt.show()
    plt.savefig('btc_price_history_candlestick-chart.png')
    ```

Now create a Jenkins job to run the Python script every minute!

1. Create a new job:

    - Name: `get current Bitcoin price`
    - Type: `Freestyle project`
    - Click `OK`

2. Define a schedule: `* * * * *`

3. Add a new `Execute shell` build step:

    ```sh
    . /home/<USERNAME>/.virtualenvs/de3/bin/activate
    python /home/<USERNAME>/<SCRIPT_NAME>.py
    ```

### Move the script to a git repository

1. Create a new gist on GitHub (to demo a super simple git repository).
2. Add the script to the repository along with a `requirements.txt` file for the
   Python dependencies.
3. Configure the Jenkins job to use the git repository as the source code
   management. Find the git repository URL in the "Clone via HTTPS" button,
   which returns the gist's URL with a `.git` suffix. Also note that the default
   `master` branch name will not work, as Github defaults to the more modern
   `main` branch name, so udpate that in the Jenkins job configuration.
4. Update the `Execute shell` build step to refer to the script in the git
   repository instead of the hardcoded local path.

Example solution: https://gist.github.com/daroczig/9e4004bbb6532edb6da384260da201c2

Example command to run the script:

```sh
. /home/<USERNAME>/.virtualenvs/de3/bin/activate
python btcprice.py
```

### Create a Docker image for the script

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

2. Make sure you have the Python script and the `requirements.txt` file locally
   (on the RStudio Server instance).

3. Create a Dockerfile to build the image:

    ```dockerfile
    FROM python:3.11-slim
    RUN pip install matplotlib pandas python-binance
    WORKDIR /app
    ADD my_local_file.py /app/btcreport.py
    CMD ["python3", "btcreport.py"]
    ```

4. Build the image:

    ```shell
    sudo docker build -t btcprice .
    ```

5. Run the container:

    ```shell
    sudo docker run --rm -ti btcprice
    ```

    Where are the images stored?
6. Update the Python script to write to a special folder, e.g. `/outputs`, and
   attach it from outside of the container.

    ```shell
    sudo docker run --rm -ti -v /home/<USERNAME>/outputs:/outputs btcprice
    ```

7. Update the Jenkins job to run the container and attach the output folder.

8. Optionally start using the Docker Jenkins plugin instead of issuing the
   `docker run` command(s) in the `Execute shell` build step.

### Scheduler improvements

Let's set up e-mail notifications via eg https://app.mailjet.com/signin

1. 💪 Sign up, confirm your e-mail address and domain
2. 💪 Take a note on the SMTP settings, eg

    * SMTP server: in-v3.mailjet.com
    * Port: 465
    * SSL: Yes
    * Username: ***
    * Password: ***

3. 💪 Configure Jenkins at http://de3.ceudata.net/jenkins/configure

    1. Set up the default FROM e-mail address at "System Admin e-mail address": jenkins@ceudata.net
    2. Search for "Extended E-mail Notification" and configure

        * SMTP Server
        * Click "Advanced"
        * Check "Use SMTP Authentication"
        * Enter User Name from the above steps
        * Enter Password from the above steps
        * Check "Use SSL"
        * SMTP port: 465

5. Set up "Post-build Actions" in Jenkins: Editable Email Notification - read
   the manual and info popups, configure to get an e-mail on job failures and
   fixes
6. Configure the job to send the whole e-mail body as the deault body template for all outgoing emails

```shell
${BUILD_LOG, maxLines=1000}
```

Optionally, look at other Jenkins plugins, eg the Slack Notifier: https://plugins.jenkins.io/slack
