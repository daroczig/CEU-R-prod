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
        
