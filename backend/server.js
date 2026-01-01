import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./config/db.js";
// import Product from "./models/product.model.js";
// import { mongo } from "mongoose";
// import mongoose from "mongoose";
import productRoutes from "./routes/product.route.js";

dotenv.config();

const app = express();

const PORT = process.env.PORT || 5000;

app.use(express.json()); // allows us to accept JSON data in request body (req.b)

app.use("/api/products", productRoutes);

app.listen(PORT, () => {
  connectDB();
  console.log("Server started at http://localhost:" + PORT);
});

//export default app;
