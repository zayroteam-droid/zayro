const express = require('express');
const router = express.Router();
const { getPrice } = require('../controllers/bookingController');

router.post('/price', getPrice);

module.exports = router;
