const express = require("express");
const Document = require("../models/document");
const auth = require("../middlewares/auth");

const documentRouter = express.Router();

/**
 * @api {post} /docs/create Create a new document
 * @apiName CreateDocument
 */
documentRouter.post("/docs/create", auth, async (req, res) => {
  try {
    const { createdAt } = req.body;
    let document = new Document({
      uid: req.user,
      title: "Untitled Document",
      createdAt,
    });

    document = await document.save();
    res.json(document);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

/**
 * @api {get} /docs/ Get all documents from user
 * @apiName GetDocuments
 */
documentRouter.get("/docs", auth, async (req, res) => {
  try {
    let documents = await Document.find({ uid: req.user });
    console.log(documents);
    res.json(documents);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = documentRouter;