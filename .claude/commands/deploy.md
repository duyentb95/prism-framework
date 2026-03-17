Export and prepare scripts for production deployment.

Pipeline: $ARGUMENTS

1. Collect all pipeline scripts
2. Create requirements.txt / package.json
3. Create Dockerfile + docker-compose.yml
4. Create config.yaml with env var references (no hardcoded secrets)
5. Create deployment README with instructions for OpenClaw / Railway / VPS
