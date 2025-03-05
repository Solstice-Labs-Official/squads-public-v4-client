# Use a minimal base image
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Enable Yarn (since corepack is built-in with Node.js 20)
RUN corepack enable && corepack prepare yarn@1.22.22 --activate

# Ensure consistent timestamps for deterministic builds
ENV NODE_ENV=production
ENV SOURCE_DATE_EPOCH=315532800

# Copy dependencies first (for better caching)
COPY package.json yarn.lock ./

# Install dependencies in a reproducible way
RUN yarn install --frozen-lockfile --non-interactive --check-files --ignore-scripts

# Copy the full source code after dependencies are cached
COPY . .

# Build the application using Webpack
RUN yarn build

# Ensure consistent timestamps for all files in dist/
RUN find dist -exec touch -d @${SOURCE_DATE_EPOCH} {} + && \
    find dist -exec chmod 644 {} +

# Prepare final output structure
RUN mkdir -p /squads-public-build/dist && \
    mv dist/* /squads-public-build/dist && \
    cd /squads-public-build/dist && \
    find . -type f -print0 | sort -z | xargs -0 cat | sha256sum | awk '{ print $1 }' > /squads-public-build/hash.txt

# Set proper permissions
RUN chmod -R u+rwX,go+rX /squads-public-build/dist && \
    chmod u+rw,go+r /squads-public-build/hash.txt

# Copy the build output to a standard location
RUN mkdir -p /output && cp -r /squads-public-build/* /output/

# Default command to print the build hash
CMD ["sh", "-c", "cat /output/hash.txt"]
