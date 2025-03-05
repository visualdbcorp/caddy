# Visual DB with Caddy SSL Termination

This repository contains a Docker Compose setup for running Visual DB with Caddy as an HTTPS reverse proxy in a private Docker network. This configuration provides secure SSL termination for intranet use.

## Overview

The setup consists of:

- **Visual DB**: The main application container
- **Caddy**: A modern web server that automatically handles HTTPS certificates
- **Docker Bridge Network**: Provides private networking between containers
- **Docker Compose**: Orchestrates the containers and network setup

## Prerequisites

- Windows OS
- Docker Desktop installed and running
- Basic knowledge of command line operations
- Administrator privileges (for editing hosts file)

## Files Included

- `docker-compose.yml`: Defines the Docker services and network
- `Caddyfile`: Caddy configuration file for reverse proxy and SSL
- `.env`: Environment variables for Visual DB
- `setup.cmd`: Windows batch file to set up the environment
- `stop.cmd`: Windows batch file to stop all services
- `restart.cmd`: Windows batch file to restart services after configuration changes

## Installation

1. **Clone or download this repository** to your local machine

2. **Edit the hosts file**:
   - Run Notepad as Administrator
   - Open `C:\Windows\System32\drivers\etc\hosts`
   - Add this line: `127.0.0.1 visualdb.local`
   - Save the file

3. **Run the setup script**:
   - Open Command Prompt
   - Navigate to the directory containing the files
   - Run `setup.cmd`

4. **Access Visual DB**:
   - Open a web browser
   - Navigate to `https://visualdb.local`
   - You'll likely see a security warning (because of the self-signed certificate)
   - Add a security exception in your browser to proceed

## Configuration Details

### Docker Compose Configuration

The `docker-compose.yml` file sets up:

- A private bridge network (`internal`) that connects only Caddy and Visual DB
- Volume mounts for Caddy's data and configuration
- Port forwarding for HTTP (80) and HTTPS (443)
- Environment variables for Visual DB from the `.env` file

### Caddy Configuration

The `Caddyfile` configures Caddy to:

- Serve `visualdb.local` over HTTPS using a self-signed certificate
- Forward all traffic to the Visual DB container
- Set appropriate headers for the reverse proxy
- Log access to a log file

### Visual DB Environment Variables

The `.env` file must be filled in with valid values before first use:
```
VDB_HOST_ID=********************************
VDB_API_KEY=*******************************************
VDB_ENCRYPTION_KEY=**********************
VDB_TOKEN_SECRET=**************************************************************************************
```

These are passed to the Visual DB container during startup.

## Usage

### Starting the Service

Run `setup.cmd` to start all services:
```
setup.cmd
```

### Stopping the Service

Run `stop.cmd` to stop all services:
```
stop.cmd
```

### Restarting After Configuration Changes

If you modify the Caddyfile or other configuration files, run `restart.cmd` to apply changes:
```
restart.cmd
```

## Troubleshooting

### Browser Shows "Connection Refused"

- Check if Docker is running
- Verify the hosts file entry is correct
- Run `docker ps` to confirm both containers are running
- Check Caddy logs: `docker logs caddy`

### Certificate Warnings

This setup uses Caddy's internal CA to generate self-signed certificates. This is normal for internal/intranet use. Options to handle this:

1. **Add a security exception** in your browser (simplest option)
2. **Import Caddy's root certificate** to your system's trusted store:
   - The root certificate can be found in the `caddy_data` volume
   - Detailed instructions for importing certificates vary by operating system

### Ports Already in Use

If ports 80 or 443 are already in use by another service (like IIS, Skype, or another web server):

1. Stop the conflicting service
2. Or modify the `docker-compose.yml` file to use different ports:
   ```yaml
   ports:
     - "8080:80"  # Change 8080 to any available port
     - "8443:443" # Change 8443 to any available port
   ```
   Then update your browser URL accordingly (e.g., `https://visualdb.local:8443`)

## Customization

### Changing the Domain Name

To use a different domain name:

1. Edit the `Caddyfile` and replace all instances of `visualdb.local` with your preferred name
2. Update your hosts file with the new domain name
3. Run `restart.cmd` to apply changes

### Adding Multiple Domains

To serve Visual DB on multiple domain names, add additional blocks to your Caddyfile:

```
visualdb.local, dashboard.local {
    tls internal
    reverse_proxy visualdb:80
}
```

Remember to add all domain names to your hosts file.

## Security Considerations

This setup is designed for intranet use and features:

- HTTPS with self-signed certificates
- Isolation via Docker's private networking
- No direct access to the Visual DB container from outside Docker

For production or internet-facing deployments, consider:

- Using real SSL certificates
- Implementing additional security measures
- Consulting with a security professional

## Maintenance

### Updating Images

To update to newer versions of Visual DB or Caddy:

1. Edit the `docker-compose.yml` file to specify the desired image versions
2. Run `restart.cmd` to pull new images and restart containers

### Viewing Logs

To view container logs:

```
docker logs visualdb   # View Visual DB logs
docker logs caddy      # View Caddy logs
```

For continuous log monitoring, add `-f` flag:

```
docker logs -f caddy
```
