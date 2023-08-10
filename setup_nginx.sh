#!/bin/bash

# Update package lists
sudo apt update

# Install Nginx
sudo apt install nginx -y

# Create directory for the new virtual host
sudo mkdir -p /var/www/work.codepark.co.uk/html

# Set appropriate permissions
sudo chown -R $USER:$USER /var/www/work.codepark.co.uk/html
sudo chmod -R 755 /var/www/work.codepark.co.uk

# Create a basic index.html file
echo "<html>
<head>
    <title>Welcome to work.codepark.co.uk</title>
</head>
<body>
    <h1>Success! Nginx is working on work.codepark.co.uk</h1>
</body>
</html>" | sudo tee /var/www/work.codepark.co.uk/html/index.html

# Create a new Nginx server block config
sudo tee /etc/nginx/sites-available/work.codepark.co.uk <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name work.codepark.co.uk www.work.codepark.co.uk;

    root /var/www/work.codepark.co.uk/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Create a symbolic link to enable the site
sudo ln -s /etc/nginx/sites-available/work.codepark.co.uk /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx

echo "Nginx has been installed and configured for work.codepark.co.uk"
