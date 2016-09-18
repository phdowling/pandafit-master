/**
 * Created by dowling on 17/09/16.
 */
var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');

var numUsers = 0;

var User = mongoose.model('User', {
    name: String,
    avatarName: String,
    userId: String,
    score: Number,
    activityLevel: Number
});

function saveUser(name, avatarName, activityLevel, callback) {
    var newUser = new User({ name: name, avatarName: avatarName, activityLevel: activityLevel, userId: "" + (numUsers + 1), score: 50});
    newUser.save(function (err, res) {
        if(err){
            console.log(err);
        } else {
            console.log('Saved user.');
            if (callback){
                callback(res);
            }
        }
    });
    numUsers++;
}

function createSomeUsers() {
    console.log("Creating some test users!");
    saveUser('Philipp', 'Gini 2.0', "Philipp");
    saveUser('Felix', 'Schwarzenpanda', 3);
}

User.find({}).count().then(function (err, nUsers) {
    if (err) return console.error(err);
    numUsers = nUsers || 0;

    console.log("numUsers: " + nUsers);
    if (!nUsers){
        createSomeUsers();
    }else {
        User.find({}, function (res) {
            console.log(res);
        });
    }
});

var pokemon = ["Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise", "Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata", "Raticate", "Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "Nidoran♀", "Nidorina", "Nidoqueen", "Nidoran♂", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Vulpix", "Ninetales", "Jigglypuff", "Wigglytuff", "Zubat", "Golbat", "Oddish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat", "Venomoth", "Diglett", "Dugtrio", "Meowth", "Persian", "Psyduck", "Golduck", "Mankey", "Primeape", "Growlithe", "Arcanine", "Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam", "Machop", "Machoke", "Machamp", "Bellsprout", "Weepinbell", "Victreebel", "Tentacool", "Tentacruel", "Geodude", "Graveler", "Golem", "Ponyta", "Rapidash", "Slowpoke", "Slowbro", "Magnemite", "Magneton", "Farfetch'd", "Doduo", "Dodrio", "Seel", "Dewgong", "Grimer", "Muk", "Shellder", "Cloyster", "Gastly", "Haunter", "Gengar", "Onix", "Drowzee", "Hypno", "Krabby", "Kingler", "Voltorb", "Electrode", "Exeggcute", "Exeggutor", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan", "Lickitung", "Koffing", "Weezing", "Rhyhorn", "Rhydon", "Chansey", "Tangela", "Kangaskhan", "Horsea", "Seadra", "Goldeen", "Seaking", "Staryu", "Starmie", "Mr. Mime", "Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir", "Tauros", "Magikarp", "Gyarados", "Lapras", "Ditto", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Porygon", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini", "Dragonair", "Dragonite", "Mewtwo", "Mew"];

function createRandomUser(name, callback){
    var randPkmn = pokemon[Math.floor(Math.random() * pokemon.length)];
    var activity = Math.floor(Math.random() * 3) + 1;
    var randscore = Math.floor(Math.random() * 130);
    var newUser = new User({ name: name, avatarName: randPkmn, activityLevel: activity, userId: name, score: randscore});
    newUser.save(function (err, res) {
        if(err) console.log(err);
        callback(res);
    });
}

var to = setTimeout(deductPoints, 10 * 1000);

function deductPoints(id, arch){
    console.log("Decaying points..");
    User.update({"score": {"$gt": 1.9999999}}, {'$inc': {"score": -1}}, {multi: true}).exec();
    to = setTimeout(deductPoints, 10 * 1000);
}
console.log('done');


module.exports = {
  User: User,
  createRandomUser: createRandomUser
};



