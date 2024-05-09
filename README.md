# Railsify: Deploying Ruby on Rails with Nginx and Passenger on AWS EC2

## Setting Up EC2 Instance with Ubuntu
1. **Create EC2 Instance:**
    - Log in to AWS Management Console.
    - Navigate to EC2 dashboard.
    - Click on "Launch Instance" and select Ubuntu AMI.
    - Configure instance details, such as instance type, VPC, and subnet.
    - Add storage if needed.
    - Configure security group to allow SSH (port 22) and HTTP (port 80) traffic.
    - Review and launch the instance.
2. **Connect to EC2 Instance:**
    - Once the instance is launched, connect to it using SSH.
    - Use the command `ssh -i your-key.pem ubuntu@your-instance-public-ip`.
3. **Update and Install Dependencies:**
    ```bash
    sudo apt-get -y update
    sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3
    ```
    - Updates package list and installs essential packages for Ruby and Rails development.
4. **Install Ruby and Bundler:**
    ```bash
    wget https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.1.tar.gz
    tar -xzf ruby-3.3.1.tar.gz
    cd ruby-3.3.1/
    ./configure
    make
    sudo make install
    echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
    sudo gem install bundler
    ```
    - Downloads and installs Ruby, the programming language used by Rails.
    - Configures and compiles Ruby.
    - Installs Bundler, a tool for managing Ruby dependencies.
5. **Install Passenger and Nginx:**
    ```bash
    sudo gem install passenger
    sudo passenger-install-nginx-module
    ```
    - Installs Passenger, a web server and application server for Ruby.
    - Configures Nginx with Passenger module for deploying Rails applications.
6. **Configure Nginx:**
    - Open the Nginx default configuration file:
        ```bash
        sudo nano /etc/nginx/sites-available/default
        ```
    - Inside the server block, find and comment out the following lines. These lines specify the default server configuration, which we'll override with our custom settings:
        ```nginx
        # listen 80 default_server;
        # listen [::]:80 default_server ipv6only=on;
        ```
    - These lines are commented out to prevent the default server configuration from conflicting with our custom settings.

    - Save the changes and exit the file.

    - Create a new configuration file for your Ruby application:
        ```bash
        sudo nano /etc/nginx/sites-available/myapp
        ```
    - Add the following server block to the new configuration file. Customize the server_name, passenger_app_env, and root directives according to your setup:
        ```nginx
        server {
            listen 80 default_server;
            server_name www.mydomain.com;
            passenger_enabled on;
            passenger_app_env development;
            root /home/rails/testapp/public;
        }
        ```
    - Explanation of the server block:
        - `listen 80 default_server;`: Defines the port on which Nginx will listen for incoming connections. Port 80 is the standard HTTP port.
        - `server_name www.mydomain.com;`: Specifies the domain name for which this server block will handle requests. Replace "www.mydomain.com" with your actual domain.
        - `passenger_enabled on;`: Enables the Passenger module to serve Ruby applications.
        - `passenger_app_env development;`: Sets the environment for the Ruby application. Change "development" to "production" for production environments.
        - `root /home/rails/testapp/public;`: Specifies the root directory of the Ruby application. Adjust the path to match the location of your Rails application's public folder.

    - Save the changes and exit the file.
## Deploying Ruby on Rails Application with Nginx and Passenger
1. **Install Rails and Create New App:**
    - Rails is a popular web application framework written in Ruby. It provides a structure for developing web applications quickly and efficiently.
    - To install Rails, we use the command:
        ```bash
        sudo gem install rails
        ```
        - `sudo`: Executes the command with administrative privileges.
        - `gem install rails`: Installs the Rails gem from the RubyGems repository.
    - Once Rails is installed, we create a new Rails application by running:
        ```bash
        rails new myapp --skip-bundle
        ```
        - `rails new myapp`: Generates a new Rails application named "myapp" in the current directory.
        - `--skip-bundle`: Skips the automatic installation of gem dependencies, which we'll handle manually.
    - Next, we navigate into the newly created application directory:
        ```bash
        cd myapp/
        ```
        - `cd`: Changes the current directory to "myapp", where our Rails application is located.
    - Finally, we install the required dependencies specified in the Gemfile by running:
        ```bash
        sudo bundle install
        ```
        - `sudo bundle install`: Uses Bundler to install all the gems specified in the Gemfile.
        - Bundler is a dependency manager for Ruby that ensures the correct versions of gems are installed for the Rails application.
2. **Configure Gemfile for Asset Pipeline:**
    - The Gemfile is a configuration file in a Rails application that specifies the gems (libraries) required for the application to run.
    - To edit the Gemfile, we use the command:
        ```bash
        nano Gemfile
        ```
        - `nano Gemfile`: Opens the Gemfile in the Nano text editor for editing.
    - Inside the Gemfile, we add the following line:
        ```ruby
        gem 'therubyracer', platforms: :ruby
        ```
        - This line adds the 'therubyracer' gem to our project. The 'therubyracer' gem provides a JavaScript runtime for Rails, which is required for executing JavaScript code in the asset pipeline.
        - The `platforms: :ruby` part ensures that the gem is only loaded in environments where Ruby is the platform, which is the case for most development and production environments.
    - After adding the gem, we save the Gemfile and exit the text editor.
    - Finally, we install the updated gem dependencies by running:
        ```bash
        sudo bundle install
        ```
        - `sudo bundle install`: Uses Bundler to install all the gems specified in the Gemfile, including the newly added 'therubyracer' gem.
        - Bundler ensures that the correct versions of gems are installed and that any dependencies are resolved.
3. **Setup Nginx Control Script:**
    - Nginx is a popular web server that can also be used as a reverse proxy, load balancer, and HTTP cache.
    - To facilitate easier management of the Nginx service, we download a control script using the following command:
        ```bash
        sudo wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh
        ```
        - `sudo wget -O init-deb.sh`: Downloads a shell script named "init-deb.sh" from the specified URL.
    - Next, we move the downloaded script to the directory where system service scripts are located:
        ```bash
        sudo mv init-deb.sh /etc/init.d/nginx
        ```
        - `sudo mv init-deb.sh /etc/init.d/nginx`: Moves the downloaded script to the "/etc/init.d/" directory and renames it to "nginx".
        - The "/etc/init.d/" directory contains startup scripts for various services on the system.
    - We then make the script executable by changing its permissions:
        ```bash
        sudo chmod +x /etc/init.d/nginx
        ```
        - `sudo chmod +x /etc/init.d/nginx`: Grants execute permissions to the Nginx control script.
        - This step allows us to run the script as a command to start, stop, or restart the Nginx service.
    - Finally, we register the Nginx service script to run at system startup:
        ```bash
        sudo /usr/sbin/update-rc.d -f nginx defaults
        ```
        - `sudo /usr/sbin/update-rc.d -f nginx defaults`: Updates the system's runlevel configuration to start the Nginx service automatically at boot time.
        - The "-f" flag forces the update, and "defaults" specifies the default runlevels for the service.
4. **Control Nginx Server:**
    - Start and stop the server manually:
        ```bash
        sudo /etc/init.d/nginx stop
        sudo /etc/init.d/nginx start
        ```
    - Manages the Nginx server service, allowing you to start or stop it as needed.
5. **Run Rails Server:**
    - The Rails server is a built-in web server provided by the Rails framework.
    - To start the Rails server, we use the command:
        ```bash
        rails server -b 0.0.0.0 &
        ```
        - `rails server`: Initiates the Rails server, allowing it to handle incoming HTTP requests.
        - `-b 0.0.0.0`: Binds the server to all available IP addresses on the host, making the application accessible from any IP address.
        - `&`: Runs the server process in the background, allowing us to continue using the terminal.
    - Additionally, you can start the Rails server using the shorthand command `rails s`.
    - If you want to specify a different port for the server, you can use the `-p` option followed by the desired port number. For example:
        ```bash
        rails server -b 0.0.0.0 -p 3000 &
        ```
    - Once the server is running, you can access your Rails application by navigating to the appropriate URL in your web browser.
    - The Rails server provides a convenient way to preview your application during development and testing.
    - Remember to keep the server running as long as you're working on your Rails application. You can stop the server by pressing `Ctrl + C` in the terminal.
6. **Security Configuration:**
    - Before accessing your Rails application, ensure that the security rules of your EC2 instance allow TCP traffic on port 3000.
    - To change the security rules in your EC2 instance:
        1. **Navigate to the EC2 Dashboard:**
            - Log in to your AWS Management Console and navigate to the EC2 dashboard.
        2. **Select the EC2 Instance:**
            - From the list of instances, select the instance associated with your Rails application.
        3. **Click on Security Groups:**
            - In the instance details, scroll down to the "Security groups" section and click on the security group linked to your instance.
        4. **Edit Inbound Rules:**
            - In the security group settings, locate the "Inbound rules" tab and click on "Edit inbound rules".
        5. **Add Rule for Port 3000:**
            - Add a new rule allowing TCP traffic on port 3000 by clicking on "Add rule" or "Add another rule". Select "Custom TCP" as the type, specify port 3000, and set the source to "Anywhere" (0.0.0.0/0) to allow traffic from any IP address.
        6. **Save Changes:**
            - Once you've added the rule, save the changes to update the security group configuration.
    - After updating the security rules, TCP traffic on port 3000 will be permitted, allowing users to access your Rails application.
    - Ensure to follow security best practices and restrict access to only trusted IP addresses if necessary.
