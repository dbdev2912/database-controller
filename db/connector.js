var mysql = require('mysql');

var conn = mysql.createConnection({
    host: "127.0.0.1",
    user: "moc",
    password: "root",
    database: "DIPE"

});

const { MongoClient } = require('mongodb');
const connectionString = "mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.6.2";
const dbName="dipe";

module.exports = {
    mysql: (query, callback) => {
        conn.connect( () => {
            // try{
            //     conn.query(query, (err, result, fields) => {
            //         callback(result)
            //     })
            // }
            // catch (err){
            //     callback([]);
            // }
            // console.log("\nConnector.js at 26: " + query.slice(0, query.length / 4) + "..." + query.slice(query.length * 3 / 4, query.length ) )
            conn.query(query, (err, result, fields) => {
                callback(result)
            })
        })
    },
    mongo: (callback) => {
        MongoClient.connect(connectionString, function(err, db) {
            if (err) throw err;
            const dbo = db.db(dbName);
            callback(dbo);
        })
    }
}
