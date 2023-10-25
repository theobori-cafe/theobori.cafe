# ☕ theobori.cafe

![build](https://github.com/theobori-cafe/theobori.cafe/actions/workflows/build.yml/badge.svg)
![publish](https://github.com/theobori-cafe/theobori.cafe/actions/workflows/publish.yml/badge.svg)

## ℹ️ About

Personal website + archives / blog

## 📖 How to build and run ?

1. Get a node environment
2. Install `npm`
3. Install the dependencies with `npm i`
4. Run as`npm run build && npm run serve`

## 🐋 Docker

```bash
docker build -t theobori .
docker run -d -p 8080:8080 theobori
```

## 📡 Other protocols

The `Gemtext` version for `Gemini` has been test with the [lagrange](https://github.com/skyjake/lagrange) client.  For `Gopher` it works well with the [phfetch](https://github.com/xvxx/phetch) client.

## 🎉 Tasks

- [x] Dockerfile
- [x] CI/CD pipeline
- [x] Migrate every post from the old website GitHub archive
- [x] Update the Gopher and Gemini version
