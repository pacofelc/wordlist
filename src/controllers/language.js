const Pool = require('pg').Pool
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'wordlist',
    password: 'postgres',
    port: 5433,
})

exports.findWordListTranslation = (req, res) => {
    //let params = { languageId: req.languageId, listId: req.listId }
    let languageId = req.query.languageId;
    let listId = req.query.listId;

    pool.query(
        ' SELECT w.word,wla.translation '+
        ' FROM wordlist.word_languages wla ' +
        ' join wordlist.word_lists wli on wla.word_id=wli.word_id ' +
        ' join wordlist.words w on w.id=wli.word_id ' +
        ' where wla.language_id = $1 and wli.list_id=$2 ',
        [languageId,listId],
        (error, results) => {
        if (error) {
            throw error
        }
        res.status(200).json(results.rows)
    })
}

exports.findWordTranslation = (req, res) => {
    //let params = { languageId: req.languageId, listId: req.listId }
    let languageId = req.query.languageId;
    let wordId = req.query.wordId;

    pool.query(
        ' SELECT w.id,w.word,wla.translation '+
        ' FROM wordlist.word_languages wla ' +
        ' join wordlist.words w on w.id=wla.word_id ' +
        ' where wla.language_id = $1 and w.id=$2 ',
        [languageId,wordId],
        (error, results) => {
            if (error) {
                throw error
            }
            res.status(200).json(results.rows)
        })
}

exports.listCreate = (req, res) => {
    let name = req.body.name;
    let description = req.body.description;

    if ( !name )
        return res.status(400).json({msg: "field name is mandatory"})

    pool.query(
        ' INSERT INTO wordlist.lists '+
        ' (name,description) values ' +
        ' ($1,$2) returning id,name,description',
        [name,description],
        (error, results) => {
            if (error) {
                return res.status(500).json({msg: error.message});
            }
            res.status(201).json( results.rows[0] )
        })
}

exports.wordCreate = (req, res) => {
    let word = req.body.word;

    if ( !word )
        return res.status(400).json({msg: "field word is mandatory"})

    pool.query(
        ' INSERT INTO wordlist.words '+
        ' (word) values ' +
        ' ($1) returning id,word',
        [word],
        (error, results) => {
            if (error) {
                return res.status(500).json({msg: error.message});
            }
            res.status(201).json( results.rows[0] )
        })
}
