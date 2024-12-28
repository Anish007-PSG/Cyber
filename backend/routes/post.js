const express = require('express');
const Post = require('../models/post');
const auth = require('../middleware/auth');

const router = express.Router();

// Create a post
router.post('/', auth, async (req, res) => {
  try {
    const post = new Post({ content: req.body.content, createdBy: req.user._id });
    await post.save();
    res.status(201).json(post);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Get all posts
router.get('/', async (req, res) => {
  try {
    const posts = await Post.find().populate('createdBy', 'username');
    res.json(posts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Update a post
router.put('/:id', auth, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);
    if (!post) return res.status(404).json({ message: 'Post not found' });

    if (req.user.role !== 'admin' && post.createdBy.toString() !== req.user._id) {
      return res.status(403).json({ message: 'Access denied' });
    }

    post.content = req.body.content;
    await post.save();
    res.json(post);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
