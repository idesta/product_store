import express from "express";

import mongoose, { get } from "mongoose";
import Product from "../models/product.model.js";
import {
  getProduct,
  createProduct,
  deleteProduct,
  updateProduct,
} from "../Controller/product.controller.js";

const router = express.Router();

// GET /api/products
router.get("/", getProduct);

// POST /api/products
router.post("/", createProduct);

// PUT /api/products/:id
router.put("/:id", updateProduct);

// DELETE /api/products/:id
router.delete("/:id", deleteProduct);

export default router;
