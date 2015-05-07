/**
 * Module dependencies
 */
var express = require('express');
var firstController = require('../controllers/firstController');
var secondController = require('../controllers/secondController');
/**
 * the new Router exposed in express 4
 * the router handles all requests to the `/` path
 */
var router = express.Router();

/**
 * this accepts all request methods to the `/` path
 */
router.route('/')
  .all(function (req, res) {
    res.render('index', {
      title: 'rtc-chat'
    });
  });

router.route('/first').all(firstController);
router.route('/second').all(secondController);

exports.indexRouter = router;
