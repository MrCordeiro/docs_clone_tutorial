const cors = require("cors");
const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
require("dotenv").config();

const PORT = process.env.PORT || 3001;
const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@docs.rwkhrmh.mongodb.net/?retryWrites=true&w=majority`;

const app = express();

// Middlewares
// Allows cross-origin requests
app.use(cors());
// Parses incoming JSON requests and puts the parsed data in req.body
app.use(express.json());
// Routes
app.use(authRouter);

// Connections
mongoose.connect(DB)
	.then(() => console.log("Connected to MongoDB"))
	.catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => console.log(`Server is running on port ${PORT}`));
