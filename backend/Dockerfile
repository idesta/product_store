  # ---------- BACKEND BUILD ----------
FROM node:18-alpine AS build
 
WORKDIR /app

# Copy root package.json (since backend uses it) & install dependencies
COPY ../package*.json ./
RUN npm install --production

# Copy backend source code
COPY ../backend ./backend
 
# Copy frontend source and build it
COPY ../frontend ./frontend
WORKDIR /frontend
RUN npm install
RUN npm run build

# ---------- FINAL IMAGE ----------
FROM node:18-alpine

WORKDIR /app

# Copy package.json and install production dependencies
COPY ../package*.json ./
RUN npm install --production --only=production
 
# Copy backend source code
COPY ../backend ./backend

# Copy built frontend to backend for serving in production
COPY --from=build /frontend/dist ./frontend/dist

EXPOSE 5000

CMD ["node", "backend/server.js"]