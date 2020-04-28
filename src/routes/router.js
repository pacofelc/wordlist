const express = require('express');

const languageController = require('../controllers/language');

let router = express.Router();


router.post('/list', languageController.listCreate);
router.post('/word', languageController.wordCreate);

router.get('/word-list', languageController.findWordListTranslation);
router.get('/word', languageController.findWordTranslation);


module.exports = router;
