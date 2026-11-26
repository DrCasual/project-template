# project-template

Starting point for new Jonc. Studios projects. It comes with CI, Docker images on GHCR, automatic deploys to staging, and releases to production through version tags. The pipelines themselves live in [devops-templates](https://github.com/DrCasual/devops-templates), so this repo only holds the calls and project settings.

## Start a new project

1. On GitHub: **Use this template → Create a new repository** (private).
2. Clone it and fill in the placeholders:
   ```bash
   bash init.sh <app> <domain> <staging-port> <production-port>
   git rm init.sh && git commit -am "Initialise from project-template" && git push
   ```
3. Replace this README with the project's own README.
4. In the new repo on GitHub:
   - **Settings → Actions → General → Workflow permissions:** "Read and write permissions".
   - **Settings → General → Pull Requests:** allow squash merging only, and turn on "Automatically delete head branches".
5. On the server: add a runner, the deploy folders, nginx and DNS. See [server setup](https://github.com/DrCasual/devops-templates/blob/main/docs/server-setup.md).

## What's inside

| Path | Purpose |
|---|---|
| `.github/workflows/ci.yml` | Pull requests: labels, Python and Node checks, Docker build with smoke test. Remove the stacks the project doesn't use. |
| `.github/workflows/staging.yml` | Merge to `main`: image `sha-<7>` → staging. |
| `.github/workflows/release.yml` | Tag `vYEAR.MONTH.N` (e.g. `v2026.11.0`): same image → production, plus a GitHub Release. |
| `.github/release.yml` | Release notes grouped as *New / Fixed / Maintenance*. |
| `.github/pull_request_template.md` | PR description template. |
| `deploy/compose.yaml` | Stack on the server (app + Postgres). Secrets stay in the server's `.env`. |
| `deploy/backup.sh` | Database dump before every deploy. |
| `deploy/smoke.sh` | CI test: start the built image with its database and call `/health`. |

## What the app needs

- A Dockerfile with `ARG APP_COMMIT`, and a `GET /health` that answers 2xx and includes that commit. The deploy waits for exactly that commit.
- The app listens on port 8000 in the container and reads `DATABASE_URL`.

## Conventions

[Branches, pull requests, releases, hotfixes, rollback](https://github.com/DrCasual/devops-templates/blob/main/docs/conventions.md)
