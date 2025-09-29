# Seribase

Backend services for mobile apps

## Diagram

![Seribase](./diagram/seribase.excalidraw.png)

## Description

Seribase supports the following services

- User registration and authentication
- REST API for structured data

Seribase use the following open source software

- KrankenD
- Supabase
- Keycloak
- PostgreSQL

## How to Update (Submodules) Kuala and Bayeu for Server Deployment

- **Kuala API**: `/submodules/kuala-api/` - Authentication and API functions
- **Bayeu**: `/submodules/bayeu/` - Payment processing functions

### Architecture

```text
base/
├── ansible/roles/
│   ├── kuala/files/kuala/volumes/functions/     ← Kuala functions deployed here
│   └── payment/files/payment/volumes/functions/ ← Bayeu functions deployed here
└── submodules/
    ├── kuala-api/supabase/functions/            ← Source for kuala functions
    └── bayeu/supabase/functions/                ← Source for bayeu functions
```

### Step-by-Step Update Process

```bash
# Navigate to base repository root
cd /path/to/base

# Update kuala-api submodule
cd submodules/kuala-api
git fetch origin
git checkout main  # or desired branch/tag
git pull origin main

# Update bayeu submodule  
cd ../bayeu
git fetch origin
git checkout main  # or desired branch/tag
git pull origin main

# Return to base root
cd ../..

# Commit submodule updates
git add submodules/kuala-api submodules/bayeu
git commit -m "Update kuala-api and bayeu submodules to latest versions"
```
