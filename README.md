# Express + Mongoose Product API

Simple REST API project for teaching Git workflows.

## Tech

- Node.js
- Express
- Mongoose
- Vitest

## Setup

```bash
npm install
```

## Run in dev mode

```bash
npm run dev
```

## Run tests

```bash
npm test
```

## Project structure

```text
src/
  models/
    Product.js
  routes/
    productRoutes.js
  controllers/
    productController.js
  app.js
  server.js

tests/
  product.test.js
```

## Notes for students

This project intentionally contains a few small issues to practice identifying and fixing problems in Git branches.

See `ISSUES.md` for the full issue backlog with levels and acceptance criteria.

## Create GitHub issues from script

After pushing this repo and logging in with GitHub CLI:

```bash
./scripts/create-github-issues.sh
```

Resume from a specific issue number:

```bash
./scripts/create-github-issues.sh --start-from 6
```
