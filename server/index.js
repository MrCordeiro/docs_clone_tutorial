const cors = require("cors");
const express = require("express");
const http = require("http");
const socket = require("socket.io");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
const Document = require("./models/document");
require("dotenv").config();

const PORT = process.env.PORT || 3001;
const DB = `mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@docs.rwkhrmh.mongodb.net/?retryWrites=true&w=majority`;


const app = express();

const server = http.createServer(app);
const io = socket(server);


// Middlewares
// Allows cross-origin requests
app.use(cors());
// Parses incoming JSON requests and puts the parsed data in req.body
app.use(express.json());
// Routes
app.use(authRouter);
app.use(documentRouter);


// Connections
mongoose.connect(DB)
	.then(() => console.log("Connected to MongoDB"))
	.catch((err) => console.log(err));


// Socket.io
io.on("connection", (socket) => {
	console.log(`New client connected: ${socket.id}`);


	socket.on("join", (roomId) => {
		console.log(`New client joined room: ${roomId}`);
		socket.join(roomId);
	});

	socket.on("typing", (data) => {
		// Send the data to all clients except the sender
		socket.broadcast.to(data.room).emit("changes", data);
	});

	socket.on("save", (data) => {
		console.log("Saving document");
    saveData(data);
  });

	socket.on("disconnect", () => {
		console.log("Client disconnected");
	});

});

const saveData = async (data) => {
  let document = await Document.findById(data.room);
  document.content = data.delta;
  document = await document.save();
};

server.listen(PORT, "0.0.0.0", () => console.log(`Server is running on port ${PORT}`));
