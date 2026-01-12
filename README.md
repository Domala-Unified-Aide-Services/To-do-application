# 📝 Todo Application — AWS Deployment & CI Preparation

## Overview

This repository contains a **Todo application** that is currently deployed on **AWS EC2** using a traditional, production-style setup.

The purpose of this project is:
- To demonstrate **end-to-end deployment ownership**
- To establish a **clean baseline** before introducing CI/CD
- To incrementally adopt **GitHub Actions** in a controlled way

At this stage, the application is **manually deployed and verified**.  
Automated pipelines will be introduced next.

---

## Architecture

**Application type:** 3-tier web application

### Components

- **Frontend**
  - Static HTML, CSS, JavaScript
  - Served via Apache
- **Backend**
  - PHP (REST-style API)
  - Plain PHP, no framework
- **Database**
  - MariaDB (MySQL compatible)
- **Hosting**
  - AWS EC2 (Ubuntu 24.04 LTS)
  - Apache Web Server

---

## Deployment Environment

### AWS EC2

- OS: Ubuntu 24.04 LTS
- Web Server: Apache 2.4
- Runtime: PHP 8.x
- Database: MariaDB
- Access: SSH (key-based)

### Directory Layout on Server

```text
/home/ubuntu/To-do-application   → Git source repository
/var/www/html                   → Deployed runtime files
