
# Nginx Reverse Proxy  

## What is Nginx  

- Nginx is an open source high performance web server (stores, processes and delivers web pages to users) that powers many modern web applications.

## What is a forward proxy?  
- A forward proxy, often called a proxy, proxy server, web proxy, is a server that sits in front of a group of client machines
- When those computers make requests to sites and services on the Internet, the proxy server intercepts those requests and then communicates with web servers on behalf of those clients, like an intermediary.


## What is a reverse proxy?  
Reverse proxies control access to a server on private networks. A reverse proxy can perform authentication tasks, as well as cache or decrypt data.



## Multi-Machine Vagrant 

## Todo 
1. Clone or fork the repo 
2. Vagrant up in the terminal 
3. In you browser run development.local:3000 to check if link is working with port
4. Run development.local/fibonacci/7 to check if fibonacci is working
5. Run development.local/posts 

### Dependencies
Before following the instructions to run a reverse proxy, please do the following and download:
1. Ruby
2. Vagrant 2.2.7
3. Oracle Virtual Box 6.1
4. test_installation 

Follow [installation guide](https://github.com/marwai/vb_vagrant_installtion) for more details 

### Instructions
 
1. First navigate to the directory with the vagrantfile, using cd to move into a directory and cd .. to move back 
    ``` 
    $ cd solution-code-environment-vars	
    # navigate to /solution-code-environment folder using code above 
    ```

![Vagrant overview](images/vagrant_overiew.PNG)

2. Once you have navigated to the correct directory run 'vagrant up' in the terminal 
    ```
    $ Vagrant up 
    ```

3. Initialise the app secure shell using 
    ```
    $ vagrant ssh app
    ```

4. Navigate to the sites
    ```
    $ cd /etc/nginx/sites-default 
    ```
5. Look in the default folder using 'nano'
    ```
    $ nano default 
    $ sudo rm -r default
    # Sudo rm -r will remove the default file as a admin (sudo) and rm removes the file, -r 
    (recursively) meaning files are removed until everything is removed.
    ```
   
6. Check to see files present in site available
    No files will be in sites available 
    ```
    # There should be no files. Run "ls -a".
    # ls lists all the files. -a includes all the hidden files too. 
    $ ls - a 
    ```
    
7. 'touch filename' to make a new default folder:
    ```
    $ touch default
    ``` 
    - make again

8. In case admin privileges are required, add sudo 
    ```
    $ sudo touch default 
    ```

9. sudo nano default. 'nano' lets you writes in the file. Reverse proxy is made by connecting to port 3000
    
    ```
    $ server {
        listen 80;
        server_name _;
        location / {
            proxy_pass http://localhost:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
    
    cntrl s 
    ```
    
10. The next command will reset the configuration and test it:
    ```
    $ sudo nginx -t 
    ```
11. Changes to nginx means the system has to be restarted:
    ```
    $ sudo systemctl restart nginx 
    $ sudo systemctrl status nginx
    ```
12. Go back to the OS
    
    ```
    # node app.js starts the node 
    $ node app.js
    ```


14. Finally check the browser
    ```
    $ development.local:3000
    $ development.local:3000/fibonacci/7
    ```
## Automation reverse proxy in a development environment
1.0 
  
        $ sudo unlink /etc/nginx/sites-enabled/default
        $ cd /etc/nginx/sites-available
        $ sudo touch reverse-proxy.conf
        $ sudo chmod 666 reverse-proxy.conf
        $ echo "server{
          listen 80;
          location / {
              proxy_pass http://192.168.10.100:3000;
          }
        }" >> reverse-proxy.conf
        $ sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
        $ sudo service nginx restart
        
        # install git
        $ sudo apt-get install git -y
    
__The code above will be broken down for explanation__

1.1

     $ sudo unlink /etc/nginx/sites-enabled/default
     # 'Unlink' removes the symlink from the default file so it is no longer in use
    

1.2

    $ cd /etc/nginx/sites-available
    
Navigates to the folder to create a new file

1.3 Creates the reverse-proxy configuration file  
  
    $ sudo touch reverse-proxy.conf
    

1.4 Changes the file permission to have read and write access but not executable   
    
    $ chmod 666
    

1.5 echo commands displays the text, '>>' redirects the output to a file   
    
    $ echo "server{
      listen 80;
      location / {
          proxy_pass http://192.168.10.100:3000/;
      }
    }" >> reverse-proxy.conf
    

1.6. ln creates an symbolic link to an existing file so the conf file that was created will be linked       

    $ sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf>                  
    $ sudo service nginx restart
___ 
   
2.0 In the os, in /environment, make a new file using ```mkdir app```, within that ```nano provision.sh```
Insert the following below in the provision folder:
  
  
    # install nodejs
    $ sudo apt-get install python-software-properties
    $ curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    $ sudo apt-get install nodejs -y
    
    # install pm2
    $ sudo npm install pm2 -g
    
    # App set up
    $ export DB_HOST="mongodb://192.168.10.150:27017/posts"
    $ cd /home/ubuntu/app
    $ sudo su
    $ npm install
    $ node app.js

Use ```nano provision.sh``` to enter the file, save the file using ```cntrl + s``` and hit ```enter```
leave the file using ```cntrl + x```
   
2.1    
Once you have left provisions folder, navigate back to the /environment using ```cd ..```, once again use ```mkdir db```
to make a folder called directory called db. Make another provisions folder with ```nano provision.sh``` 

Enter the following in the /db provision folder.

```html
# be careful of these keys, they will go out of date
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
$ echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# sudo apt-get install mongodb-org=3.2.20 -y
$ sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20

# remoe the default .conf and replace with our configuration
$ sudo rm /etc/mongod.conf
$ sudo ln -s /home/ubuntu/environment/mongod.conf /etc/mongod.conf

# if mongo is is set up correctly these will be successful
$ sudo systemctl restart mongod
$ sudo systemctl enable mongod

```
---
3.0   
Navigating to vagrantfile and editing it
Once you have saved the db app folder. Navigate to the solutions-code-environment wiht the vagrant file.
Enter the file using ```nano vagrantfile```

In the code, insert:

        # Install required plugins
    required_plugins = ["vagrant-hostsupdater"]
    required_plugins.each do |plugin|
        exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end
    
    def set_env vars
      command = <<~HEREDOC
          echo "Setting Environment Variables"
          source ~/.bashrc
      HEREDOC
    
      vars.each do |key, value|
         command += <<~HEREDOC
          if [ -z "$#{key}" ]; then
              echo "export #{key}=#{value}" >> ~/.bashrc
          fi
        HEREDOC
      end
    
      return command
    end
    
    Vagrant.configure("2") do |config|
     config.vm.define "db" do |db|
        db.vm.box = "ubuntu/xenial64"
        db.vm.network "private_network", ip: "192.168.10.150"
        db.hostsupdater.aliases = ["database.local"]
        db.vm.synced_folder "environment/db", "/home/ubuntu/environment"
        db.vm.provision "shell", path: "environment/db/provision.sh", privileged: false
      end
    
      config.vm.define "app" do |app|
        app.vm.box = "ubuntu/xenial64"
        app.vm.network "private_network", ip: "192.168.10.100"
        app.hostsupdater.aliases = ["development.local"]
        app.vm.synced_folder "app", "/home/ubuntu/app"
        app.vm.provision "shell", path: "environment/app/provision.sh", privileged: false
        app.vm.provision "shell", inline: set_env({ DB_HOST: "mongodb://192.168.10.150:27017/posts" }), privileged: false
      end
    end

# Error 

After running Vagrant up, only the app vm is ran, db vm has to be manually initialised with vagrant up db. 
This error below occurred:

 app: Fetched 22.0 MB in 2s (7,710 kB/s)

    app: E
    app: :
    app: Failed to fetch https://deb.nodesource.com/node_12.x/pool/main/n/nodejs/nodejs_12.18.3-1nodeso
source1_amd64.deb  Hash Sum mismatch
    app: E
    app: :
    app: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
    app: sudo
    app: : npm: command not found
The SSH command responded with a non-zero exit status. Vagrant
assumes that this means the command failed. The output for this command
should be in the log above. Please read the output to determine what
went wrong.
```

This was fixed through:
```
$ sudo su
$ npm install pm2 -g # in the code app root 


## After Vagrant up db, another error is thrown. Despite using the same code given in class, it was unable to connect to mongodb 
## __MONGODB__ error

     db: E: Failed to fetch https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/3.2/multiverse/
    binary-amd64/mongodb-org-server_3.2.20_amd64.deb  Hash Sum mismatch
        db:
        db: E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
        db: rm:
        db: cannot remove '/etc/mongod.conf'
        db: : No such file or directory
        db: Failed to restart mongod.service: Unit mongod.service not found.
        db: Failed to execute operation: No such file or directory
    The SSH command responded with a non-zero exit status. Vagrant
    assumes that this means the command failed. The output for this command
    should be in the log above. Please read the output to determine what
    went wrong.

![Posts_image](images/Posts_image.png)


