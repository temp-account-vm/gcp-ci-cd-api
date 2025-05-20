const express = require('express');
const app = express();
const PORT = 3000;

app.get('/captor', (req, res) => {
    res.json([{ id: 1, type: "température", valeur: 22.5 }]);
});

app.listen(PORT, () => {
    console.log(`API active sur http://localhost:${PORT}`);
});
