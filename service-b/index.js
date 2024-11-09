const express = require('express');
const axios = require('axios');
const app = express();
const PORT = 3000;

app.get('/', async (req, res) => {
    try {
        const response = await axios.get('http://service-a:3000'); // Llama a Service A
        res.send(`Service B dice: "${response.data}"`);
    } catch (error) {
        res.send('Error al conectar con Service A');
    }
});

app.listen(PORT, () => {
    console.log(`Service B escuchando en el puerto ${PORT}`);
});
