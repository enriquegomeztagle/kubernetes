const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send('Hola desde Service A');
});

app.listen(PORT, () => {
    console.log(`Service A escuchando en el puerto ${PORT}`);
});
