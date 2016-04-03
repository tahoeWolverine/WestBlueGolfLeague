var express = require('express'),
    app = express(),
    Sequelize = require('Sequelize');

var sequelize = new Sequelize('westbluegolf', 'westblue', 'westblue', {
    host: 'localhost',
    dialect: 'mysql',

    pool: {
        max: 5,
        min: 0,
        idle: 10000
    }
});


app.get('/', (req, res) => {
    sequelize.query('SELECT * FROM team', { type: sequelize.QueryTypes.SELECT }).then((results) => {
        res.send(results);
    });
});

app.listen(3000, () => console.log('listening'));

