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
    res.json(documents);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

/**
 * @api {post} /docs/title Update document title
 * @apiName UpdateDocumentTitle
 * @apiParam {String} id Document id
 * @apiParam {String} title Document title
 * @apiSuccess {Object} document Updated document
 */
documentRouter.post("/docs/title", auth, async (req, res) => {
  try {
    const { id, title } = req.body;
    const document = await Document.findByIdAndUpdate(id, { title });
    res.json(document);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

/**
 * @api {get} /docs/:id Get document by id
 * @apiName GetDocumentById
 * @apiParam {String} id Document id
 * @apiSuccess {Object} document Document
 */
documentRouter.get("/docs/:id", auth, async (req, res) => {
  try {
    const document = await Document.findById(req.params.id);
    res.json(document);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = documentRouter;