# MultiStage Ops

**MultiStage Ops** is a CI/CD pipeline designed to automate the deployment of applications using Docker containers across multiple environments: **test** and **prod**. This project leverages GitHub Actions for CI/CD, AWS EC2 instances as self-hosted runners, Docker for containerization, and an Application Load Balancer for routing traffic to different environments.

---

## Table of Contents

- [Project Overview](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Features](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Architecture](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Getting Started](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Prerequisites](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Tools Required](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Installation](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Clone the Repository](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Set Up EC2 Instances](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Install Self-Hosted Runners on EC2](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Tag Self-Hosted Runners](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Configuration](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Add GitHub Secrets](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Configure GitHub Actions Workflow](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [Set Up Route 53 and Load Balancer](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Usage](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
- [Domains and Routing](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [URLs](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)
    - [SSL Configuration](https://www.notion.so/MultiStage-Ops-11117c74f6d4808a9890df88781b9837?pvs=21)

---

## Project Overview

MultiStage Ops automates the process of building, testing, and deploying Dockerized applications across multiple environments using a branch-based GitHub Actions workflow. It ensures changes are deployed based on the branch they are pushed to:

- `master`: Deploys to the production environment.
- `test`: Deploys to the testing environment.

The project integrates with AWS EC2 instances, Docker Hub, and an Application Load Balancer to manage traffic between environments.

---

## Features

- **Multi-Stage Deployment**: Automatic deployment of applications to different environments based on GitHub branch.
- **Self-Hosted Runners**: Uses EC2 instances as self-hosted runners for efficient and customizable CI/CD workflows.
- **Dockerized Application**: Builds, pushes, and deploys Docker images for each environment.
- **Automated SSL and Domain Configuration**: Integrates AWS Route 53 and Load Balancer to route traffic to appropriate environments using subdomains.

---

## Architecture

- **CI/CD**: GitHub Actions.
- **Containers**: Docker and Docker Hub.
- **Hosting**: AWS EC2 instances for self-hosted runners.
- **Traffic Management**: AWS Application Load Balancer with Route 53 for domain management.

---

## Getting Started

### Prerequisites

Before setting up the project, ensure you have the following:

- **AWS Account** with access to EC2, ALB, and Route 53.
- **GitHub Repository**.
- **Docker Hub Account**.
- **EC2 Instances** (Test and Prod) with SSH access and Docker installed.
- **Domains** registered with Route 53 or other DNS providers.

### Tools Required

- Git
- Docker
- AWS CLI
- SSH client for EC2 access

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/your-username/multi-stage-ops.git
cd multi-stage-ops
```

### Set Up EC2 Instances

- Provision two EC2 instances (for `test` and `prod`) in AWS.
- Ensure they have:
    - **Docker installed**.
    - **Internet access**.
    - **SSH access** configured.

### Install Self-Hosted Runners on EC2

Follow these steps to install the GitHub Actions runner on each EC2 instance.

- SSH into your EC2 instance:
    
    ```bash
    ssh -i path-to-your-key.pem ec2-user@your-ec2-public-ip
    ```
    
- Download and set up the GitHub Actions runner:
    
    ```bash
    mkdir actions-runner && cd actions-runner
    curl -o actions-runner-linux-x64-2.309.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.309.0/actions-runner-linux-x64-2.309.0.tar.gz
    tar xzf ./actions-runner-linux-x64-2.309.0.tar.gz
    ```
    
- Configure and start the runner:
    
    ```bash
    ./config.sh --url https://github.com/your-org/your-repo --token YOUR_RUNNER_TOKEN
    ./svc.sh install
    sudo ./svc.sh start
    ```
    

### Tag Self-Hosted Runners

Go to **Settings** > **Actions** > **Runners** in your GitHub repository and add appropriate tags:

- `self-hosted-test` for the **test** environment.
- `self-hosted-prod` for the **prod** environment.

---

## Configuration

### Add GitHub Secrets

Navigate to your repository's **Settings** > **Secrets** and add the following secrets:

- `DOCKERHUB_USERNAME`: Your Docker Hub username.
- `DOCKERHUB_TOKEN`: Your Docker Hub access token.

### Configure GitHub Actions Workflow

In `.github/workflows/deploy.yml`, configure the workflow to trigger on `test` and `master` branches:

```yaml
on:
  push:
    branches:
      - master
      - test
```

Update the workflow to use the appropriate self-hosted runners for the test and prod environments.

### Set Up Route 53 and Load Balancer

- Create a **Route 53 Hosted Zone** for your domain.
- Set up an **Application Load Balancer** in AWS to route traffic to `mydomain.org` (prod) and `test.mydomain.org` (test).
- Configure **DNS records** to point to the load balancer.

---

## Usage

Once everything is set up, you can start deploying your application:

- **Test Environment**: Push changes to the `test` branch to deploy to the test environment (URL: `test.mydomain.org`).
- **Production Environment**: Push changes to the `master` branch to deploy to the production environment (URL: `mydomain.org`).

The GitHub Actions workflow will automatically:

- Build and push the Docker image to Docker Hub.
- Pull the image on the corresponding EC2 instance.
- Deploy the container using Docker and Nginx.

---

## Domains and Routing

### URLs

- **Production**: `mydomain.org`
- **Testing**: `test.mydomain.org`

Both subdomains are routed through an **AWS Application Load Balancer** and served by Docker containers running on EC2 instances.

### SSL Configuration

You can integrate **AWS Certificate Manager (ACM)** to generate and attach SSL certificates to your Load Balancer for secure HTTPS traffic.
