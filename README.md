Here you can find the materials for the "[Data Engineering 5: Using R in Production](https://courses.ceu.edu/courses/2020-2021/data-engineering-5-using-r-production)" course, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous editions, see [2017/2018](https://github.com/daroczig/CEU-R-prod/tree/2017-2018), [2018/2019](https://github.com/daroczig/CEU-R-prod/tree/2018-2019), [2019/2020](https://github.com/daroczig/CEU-R-prod/tree/2019-2020).

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Schedule](#schedule)
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

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-prod/issues).
