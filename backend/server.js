import express from "express";
import dotenv from "dotenv";
import path from "path";
import cors from "cors";
import { connectDB } from "./config/db.js";
// import Product from "./models/product.model.js";
// import { mongo } from "mongoose";
// import mongoose from "mongoose";
import productRoutes from "./routes/product.route.js";

dotenv.config();

const app = express();

// Enable CORS for all routes
app.use(
  cors({
    origin:
      process.env.NODE_ENV === "production" ? "*" : "http://localhost:5173", // Allow your frontend origin
  }),
);

const PORT = process.env.PORT || 5000;

const __dirname = path.resolve();

app.use(express.json()); // allows us to accept JSON data in request body (req.b)

app.use("/api/products", productRoutes);

if (process.env.NODE_ENV === "production") {
  // app.use(express.static(path.join(__dirname, "/frontend/dist")));
  app.use(express.static(path.join(__dirname, "frontend", "dist")));

  // Fallback route for SPA (catch all routes)

  app.use((req, res) => {
    res.sendFile(path.join(__dirname, "frontend", "dist", "index.html"));
  });
}

app.listen(PORT, () => {
  connectDB();
  console.log("Server started at http://localhost:" + PORT);
});
