function burbuja(numeros) {
    const ArrayNew = []
    for (var i = 1; i < numeros.length; i++) {
        for (var j = 0; j < (numeros.length - i); j++) {
            if (numeros[j].position < numeros[j + 1].position) {
                k = numeros[j + 1];
                numeros[j + 1] = numeros[j];
                numeros[j] = k;
            }
        }
    }
    ArrayNew.push([...numeros]);
    return ArrayNew;
}

(() => {
    console.log('====================================');
    console.log(burbuja([{
        name: 'Arturo',
        position: 111
    }, {
        name: 'Flaco',
        position: 5
    }, {
        name: 'Romina',
        position: 665
    }, {
        name: 'Flor',
        position: 21
    }, {
        name: 'Tere',
        position: 32
    }, {
        name: 'Luciano',
        position: 78
    }]));
    console.log('====================================');
})();