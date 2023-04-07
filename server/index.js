import cors from "cors";
import express, { json } from "express";
import { connect } from "mongoose";
require("dotenv").config();

const PORT = process.env.PORT || 3001;
const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@docs.rwkhrmh.mongodb.net/?retryWrites=true&w=majority`;

const app = express();

// Middlewares
// Allows cross-origin requests
app.use(cors());
// Parses incoming JSON requests and puts the parsed data in req.body
app.use(json());
// Routes
app.use(authRouter);

// Connections
connect(DB)
	.then(() => console.log("Connected to MongoDB"))
	.catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => console.log(`Server is running on port ${PORT}`));
