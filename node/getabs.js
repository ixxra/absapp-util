var jsdom = require('jsdom');

var data = [];

jsdom.env(
  "http://intranet.matematicas.uady.mx/journal/",
  ["http://code.jquery.com/jquery.js"],
  function (errors, window) {
    window.$('.contenedorToggle').each(function (idx, c){
        var vol = window.$('.headerText', c).text();
        var year = vol.match(/\d+/)[0];
        var volume = vol.match(/Volumen\s+\d+/)[0];

        var abs = {volume: volume, year: year};
        var contents = [];

        window.$('.publicacion tr', c).each(function (idx, pub){
            var title = window.$('.titulo a', pub).text();
            var art_type = window.$('.tipoArticulo', pub).text();
            var art_cat = window.$('.categoria', pub).text();
            var authors = window.$('.autor', pub).text();
            var doc_source = window.$('.enlaces a', pub)[0].href;
            var abstract = window.$('.abstract', pub).text();
            contents.push({
                title: title,
                article: {
                    type: art_type,
                    category: art_cat
                },
                authors: authors,
                source: doc_source,
                abstract: abstract
            });
        });
        
        abs.contents = contents;
        data.push(abs);
    });
    console.log(JSON.stringify(data));
  });

