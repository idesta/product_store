# ---------- FRONTEND BUILD ----------
FROM node:18-alpine AS frontend
WORKDIR /frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend .
RUN npm run build


# ---------- APP ----------
FROM node:18-alpine
WORKDIR /app

# copy root package.json (backend depends on this)
COPY package*.json ./
RUN npm install --production

# copy backend source
COPY backend ./backend

# copy frontend build output
COPY --from=frontend /frontend/dist ./frontend/dist

EXPOSE 5000

CMD ["npm", "start"]
