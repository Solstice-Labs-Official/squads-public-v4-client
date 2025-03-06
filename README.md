# Squads Public Client v4

This repository hosts the code for a simplified client application for the Squads V4 Program. The app can be built, verified for integrity, and deployed as a static site using multiple hosting options, including self-hostable solutions like Docker with NGINX. Here’s how you can use it effectively.

---

## Features

- **Verifiable Build**: The `dist/` directory contains the static files that can be verified via a hash. This ensures the integrity of the build delivered.
    - Verification can be done against:
        - **Remote URLs**: Downloaded files can be verified for consistency with the expected hash.
        - **IPFS CID**: Retrieve the build from IPFS and verify its authenticity.
- **Self-hosting**: Run the application as a Docker container using an NGINX server for fully self-managed hosting.

---

## Getting Started

The following steps will guide you to build, verify, and host the application.

### 1. **Build the Web App**

#### Prerequisites:
- [Node.js v20+](https://nodejs.org/)
- [Yarn](https://yarnpkg.com/)

#### Steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/Squads-Protocol/public-v4-client
   cd public-v4-client
   ```

2. Install dependencies:
   ```bash
   yarn install --frozen-lockfile
   ```

3. Build the application:
   ```bash
   yarn build
   ```
   A `dist/` directory will be created containing the static files.

---

### 2. **Verify the Build**

#### Verifying Against a Remote URL
To verify the files hosted at a remote URL:
1. Use the `scripts/verify-remove.sh` script:
   ```bash
   ./scripts/verify-remote.sh <REMOTE_URL> <EXPECTED_HASH>
   ```
   Replace `<REMOTE_URL>` with the base URL of the remote site and `<EXPECTED_HASH>` with the known SHA-256 hash of the build.

---

#### Verifying Against an IPFS CID
To verify an IPFS-hosted build:
1. Ensure you have the IPFS CLI installed (`ipfs`).
2. Use the `scripts/verify-ipfs.sh` script:
   ```bash
   ./scripts/verify-ipfs.sh <IPFS_CID> <EXPECTED_HASH>
   ```
   Replace `<IPFS_CID>` with the CID of the IPFS build and `<EXPECTED_HASH>` with the known SHA-256 hash.

---

### 3. **Self-Host with Docker**

#### Prerequisites:
- [Docker](https://www.docker.com/)

#### Run the Docker Container
You can deploy the web app via a self-hosted Docker container using NGINX:
1. Build the Docker image:
   ```bash
   docker build -t squads-public-client:v4 .
   ```

2. Run the container:
   ```bash
   docker run -d -p 8080:80 --name squads-public-client squads-public-client:v4
   ```

The app will now be available at `http://localhost:8080`.

---

### 4. **Build Hash**

The application’s build includes a SHA-256 hash for integrity verification. This hash is generated by combining all files in the `dist/` directory in a deterministic order.

#### To Check or Compute the Build Hash Locally:
1. Run the `scripts/generate-hash.sh` script:
   ```bash
   ./scripts/generate-hash.sh
   ```

   The output will show the computed hash of the local `dist/` content. This hash should match the one provided in the deployment.

---

## File Integrity During Deployment

### Manifest File
A `manifest.json` file is included in the build, containing references to all static assets. It ensures that asset file mappings remain consistent during deployment.

---

## Contributing

Contributions are welcome! Please fork the repository, make your changes, and open a pull request.

---

## License

This project is licensed under the MIT License. Please see the included `LICENSE` file for details.