# Web Development Environment Setup

This repository contains configuration files for setting up a local web development environment using Nix Flakes and Direnv. It's tailored for a PHP 7.3 project with additional services like MySQL, Redis, and Nginx.

## Overview

The `flake.nix` file in this repository declares the environment's dependencies and configuration. We're using Nix to manage packages and environments, ensuring consistency and reproducibility across different systems.

### Key Components

- **PHP 7.3**: Utilizing an older version of PHP not maintained in Nixpkgs. For this, we use the `fossar/nix-phps` repository.
- **MySQL 5.7**: For database management.
- **Redis**: An in-memory database used for caching and other purposes.
- **Nginx**: A high-performance HTTP server and reverse proxy.

## Configuration

### PHP

We have configured PHP 7.3 with the following settings:
- **Xdebug**: For debugging, with settings for client host and starting requests.
- **Error Reporting**: All errors are reported, displayed, and logged.

### MySQL

MySQL 5.7 runs with a custom datadir, pid file, socket, and is bound to localhost on port 3306. The `--skip-grant-tables` flag is used for convenience in this development setup.

### Redis

Redis is configured using a custom `redis.conf` file.

### PHP-FPM

PHP-FPM is set to use a provided configuration file.

### Nginx

Nginx is configured to log errors to a specific path and uses a custom nginx configuration file.

## Starting the Environment

The `start` script in the repository initializes all the components. It starts MySQL, Redis, PHP-FPM, and Nginx with the specified configurations.

## Usage

To use this environment:
1. Ensure you have Nix with Flakes support installed.
2. Clone this repository.
3. Navigate to the repository directory and run `direnv allow` to load the environment.
4. Execute the `start` script to launch all services.

This setup provides a comprehensive, isolated development environment for the specific PHP project, leveraging the power and flexibility of Nix.

## Integration with Laravel Nix Bootstrap

### Old Laravel Projects Bootstrap
For working with older Laravel projects that require PHP 7.3, there's a specialized setup designed to simplify the process of bootstrapping such projects. The [laravel-nix-bootstrap](https://github.com/osandell/laravel-nix-bootstrap) repository provides a streamlined way to run these older Laravel projects.

### Why Use Laravel Nix Bootstrap?
- Simplicity: Tailored to quickly set up an environment compatible with legacy Laravel applications.
- Local Composer Setup: Ensures that Composer uses the PHP version specified by Nix, which is essential for older Laravel projects.
- Direct Request Script: Includes a utility script for making direct requests to Laravel without needing Nginx, simplifying testing and internal request handling.

### How to Use
1. Visit the [laravel-nix-bootstrap](https://github.com/osandell/laravel-nix-bootstrap) repository.
2. Follow the instructions in the README to set up your Laravel project with the correct PHP version and dependencies.

### Compatibility
The laravel-nix-bootstrap setup complements this environment by focusing specifically on Laravel applications, ensuring they run smoothly with the services like MySQL, Redis, and Nginx provided here.

