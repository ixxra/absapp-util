var fs = require('fs');
var data = fs.readFileSync('meta.json');
var abs = JSON.parse(data);


function tokenize(author)
{
    var tokens = author.split(' ');
    if (tokens.length === 2) {
        return {
            first_name: tokens[0],
            last_name: tokens[1]
        };
    }

   if (tokens.length === 3) {
        return {
            first_name: tokens[0],
            last_name: tokens[1] + ' ' +tokens[2]
        };
   }

   return { 
       first_name: tokens[0],
       middle_name: tokens.slice(1, -2).join(' '),
       last_name: tokens.slice(-2).join('-')
   };
}


console.log('<?xml version="1.0" encoding="UTF-8"?>');
console.log('<!DOCTYPE users SYSTEM "users.dtd">');
console.log('<users>');

abs.forEach(function(issue) {
    issue.contents.forEach(function(article) {
        var authors = article.authors.split(/,/);
        authors[0] = authors[0].slice(8);
        authors.forEach(function (author) {
            console.log('  <user>');
            var tokens = tokenize(author.trim());
            console.log('    <first_name>');
            console.log('      ', tokens.first_name);
            console.log('    </first_name>');
            if (tokens.middle_name){
                console.log('    <middle_name>');
                console.log('      ', tokens.middle_name);
                console.log('    </middle_name>');
            }
            console.log('    <last_name>');
            console.log('      ',tokens.last_name);
            console.log('    </last_name>');
            console.log('    <role type="author">');
            console.log('  </user>');
        });
    });
});

console.log('</users>')
