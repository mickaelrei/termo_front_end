# Termo Frontend

Frontend for Termo web application

## Deploy

The script `deploy_example.ps1` is a PowerShell script containing a template for building and deploying the frontend on
the cloud. Change the parameters at the start of the script to your needs.

The script builds the project, sends it to the cloud via SSH and attempts to call a `deploy_web.sh` script on the
cloud instance. Here's the template for that script:

```bash
#!/bin/bash

# Stop on errors
set -e

echo "Deploying Flutter web build..."

# Optional: check if source exists
if [ ! -d "/tmp/flutterweb" ]; then
  echo "/tmp/flutterweb does not exist. Upload the build first."
  exit 1
fi

# Remove current site files
sudo rm -rf /var/www/html/*

# Copy new build
sudo cp -r /tmp/flutterweb/. /var/www/html/

# Set permissions
sudo chown -R www-data:www-data /var/www/html

echo "Deployment complete. App is live."
```

It is expected that the cloud instance has Apache installed and configured to serve the files from the project which are
put in the /var/www/html directory.