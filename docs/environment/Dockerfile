# Project Biometal - Documentation Environment
# API-first documentation generation from specifications

FROM node:18-slim

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DOC_FORMAT=markdown
ENV SPEC_VALIDATION=enabled

# Install documentation tools
RUN apt-get update && apt-get install -y \
    # Core utilities
    curl wget git \
    # Documentation generation
    pandoc texlive-latex-base \
    # YAML processing
    yq \
    # Python for advanced processing
    python3 python3-pip \
    # File utilities
    tree \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js documentation tools
RUN npm install -g \
    # OpenAPI documentation
    @apidevtools/swagger-parser \
    redoc-cli \
    swagger-ui-dist \
    # Markdown processing
    markdown-it \
    markdown-it-anchor \
    # Static site generation
    @11ty/eleventy \
    # YAML/JSON utilities
    js-yaml

# Install Python packages for spec processing
RUN pip3 install --no-cache-dir \
    pyyaml \
    jinja2 \
    markdown \
    pygments \
    openapi-spec-validator

# Create documentation workspace
WORKDIR /workspace
RUN mkdir -p \
    /workspace/docs \
    /workspace/spec \
    /workspace/templates \
    /workspace/generated \
    /workspace/static

# Create scripts directory (scripts will be mounted at runtime)
RUN mkdir -p /workspace/scripts

# Set up documentation generation structure
RUN mkdir -p \
    /workspace/docs/api \
    /workspace/docs/systems \
    /workspace/docs/guides \
    /workspace/docs/overview \
    /workspace/templates/api \
    /workspace/templates/systems \
    /workspace/templates/guides

# Expose documentation server port
EXPOSE 3000

# Default documentation command
CMD ["bash", "-c", "echo 'FuncOS Documentation Environment Ready' && echo 'Format: ${DOC_FORMAT} | Validation: ${SPEC_VALIDATION}' && bash"]