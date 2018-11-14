/* ******************************************************** */
/* **************** loadSoundCloudWidgets ***************** */
/* ******************************************************** */

var loadSoundCloudWidgets = function() {
    var data = [
        // Larhythmix - Lean On
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/520709931",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Strange Era (ALBUM)
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/400263989",
            id: "content_music_playlist",
            containerName: "content_music",
        },
        // Larhythmix - Fist
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/413562690",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Werm
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/307093003",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Pearl
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/297379454",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Zephyr
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/289494455",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Felicity
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/246535296",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Spellbound
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/242590173",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Hooligan
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/231581403",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Bounce
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/227543389",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Pieces
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/207838361",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Sponge
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/204992715",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Light (EP)
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/79872818",
            id: "content_music_playlist",
            containerName: "content_music",
        },
        // Larhythmix - Serene
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/157521247",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Universe
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/153080429",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Clown Jazz
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/139915180",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Wolf
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/129126384",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Wings
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/117495904",
            className: "content_music_track",
            containerName: "content_music",
        },
        // Larhythmix - Faith EP
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/7658083",
            id: "content_music_playlist",
            containerName: "content_music",
        },
        // Larhythmix - Afterparty Blues
        {
            url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/102319833",
            className: "content_music_track",
            containerName: "content_music",
        },
    ];

    loadSoundCloudWidgetSync(data, 0);
};

var loadSoundCloudWidgetSync = function(data, i) {
    loadSoundCloudWidget(data, i, function() {
        if (i+1 < data.length) {
            loadSoundCloudWidgetSync(data, i+1);
        }
    })
};

var loadSoundCloudWidget = function(data, i, callback) {
    var obj = data[i];
    var container = document.getElementById(obj.containerName);
    var frame = document.createElement("iframe");
    frame.src = obj.url;
    if (obj.className) {
        frame.className = obj.className;
    }
    if (obj.id) {
        frame.id = obj.id;
    }
    frame.style.visibility="hidden";
    frame.onload = function () {
        this.style.visibility="visible";
        if (callback) {
            callback();
        }
    };
    container.appendChild(frame);
};

/* ************************************************ */
/* **************** loadStreetArt ***************** */
/* ************************************************ */

var loadStreetArt = function() {
    var data = [
        // London
        {
            href: "https://goo.gl/photos/mhfM94ptnjmx8SRD6",
            src: "imgs/streetart/london.png",
            alt: "London",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Berlin
        {
            href: "https://goo.gl/photos/52rpgzV6HCKVZ2DdA",
            src: "imgs/streetart/berlin.png",
            alt: "Berlin",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Bristol
        {
            href: "https://goo.gl/photos/uTmTihKEs9aRCbnF7",
            src: "imgs/streetart/bristol.png",
            alt: "Bristol",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // New York
        {
            href: "https://photos.app.goo.gl/QfczFj3zrtRWWAjq2",
            src: "imgs/streetart/new-york.png",
            alt: "New York",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Los Angeles
        {
            href: "https://photos.app.goo.gl/uEtanNKVJBBEFZa12",
            src: "imgs/streetart/los-angeles.png",
            alt: "Los Angeles",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // San Francisco
        {
            href: "https://photos.app.goo.gl/DdgxC7NT3AqouYcf2",
            src: "imgs/streetart/san-francisco.png",
            alt: "San Francisco",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // San Diego
        {
            href: "https://photos.app.goo.gl/aVIW8ZOkc33a38pK2",
            src: "imgs/streetart/san-diego.png",
            alt: "San Diego",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Portland
        {
            href: "https://photos.app.goo.gl/iO4amujOgUIdvR7r1",
            src: "imgs/streetart/portland.png",
            alt: "Portland",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Brighton
        {
            href: "https://goo.gl/photos/12avm2vPgD12MhDd6",
            src: "imgs/streetart/brighton.png",
            alt: "Brighton",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Istanbul
        {
            href: "https://goo.gl/photos/MZwfkRdNJ8Q6vwD26",
            src: "imgs/streetart/istanbul.png",
            alt: "Istanbul",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Copenhagen
        {
            href: "https://photos.app.goo.gl/aqELv9M7pA9SytDG9",
            src: "imgs/streetart/copenhagen.png",
            alt: "Copenhagen",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Ljubljana
        {
            href: "https://goo.gl/photos/69VfJmZDhDvqy8bh9",
            src: "imgs/streetart/ljubljana.png",
            alt: "Ljubljana",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // San Jose
        {
            href: "https://photos.app.goo.gl/kRRlcmC5THA1QUq72",
            src: "imgs/streetart/san-jose.png",
            alt: "San Jose",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Barcalona
        {
            href: "https://goo.gl/photos/XLHQwLhFbTTUsivZ6",
            src: "imgs/streetart/barcalona.png",
            alt: "Barcalona",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Madrid
        {
            href: "https://goo.gl/photos/renPWzYr5jTtdM2g6",
            src: "imgs/streetart/madrid.png",
            alt: "Madrid",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Belgrade
        {
            href: "https://goo.gl/photos/r9DN4fHsHHrEWdw79",
            src: "imgs/streetart/belgrade.png",
            alt: "Belgrade",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Portimao
        {
            href: "https://photos.app.goo.gl/bPdHiLXooG2hBjkq7",
            src: "imgs/streetart/portimao.png",
            alt: "Portimao",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Potsdam
        {
            href: "https://photos.app.goo.gl/quyO4BdTwtyUDr303",
            src: "imgs/streetart/potsdam.png",
            alt: "Berlin",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Wroclaw
        {
            href: "https://goo.gl/photos/asribdQiFDH3frkb9",
            src: "imgs/streetart/wroclaw.png",
            alt: "Wroclaw",
            id: "content_music_playlist",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Zagreb
        {
            href: "https://goo.gl/photos/3F1kxGLUfnS6tFgh9",
            src: "imgs/streetart/zagreb.png",
            alt: "Zagreb",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Melbourne
        {
            href: "https://goo.gl/photos/U7Z4M2ejL4eqo2mC9",
            src: "imgs/streetart/melbourne.png",
            alt: "Melbourne",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Newtown
        {
            href: "https://goo.gl/photos/zG1AUVSnh6VxXNgcA",
            src: "imgs/streetart/newtown.png",
            alt: "Newtown",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Prague
        {
            href: "https://goo.gl/photos/k2kj9tcXmVpvohy98",
            src: "imgs/streetart/prague.png",
            alt: "Prague",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Bratizlava
        {
            href: "https://goo.gl/photos/ro7kGEPkrEe522jZA",
            src: "imgs/streetart/bratizlava.png",
            alt: "Bratizlava",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Krakow
        {
            href: "https://goo.gl/photos/kzPh3RtZ3YdZMzqV8",
            src: "imgs/streetart/krakow.png",
            alt: "Krakow",
            id: "content_music_playlist",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Amsterdam
        {
            href: "https://goo.gl/photos/8bYDHPGECN8BPvL67",
            src: "imgs/streetart/amsterdam.png",
            alt: "Amsterdam",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Sofia
        {
            href: "https://goo.gl/photos/7uJaRsvb5dxkcCJX6",
            src: "imgs/streetart/sofia.png",
            alt: "Sofia",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Munich
        {
            href: "https://goo.gl/photos/rtdNoqp69vrSw43N8",
            src: "imgs/streetart/munich.png",
            alt: "Munich",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Leipzig
        {
            href: "https://goo.gl/photos/55hQrp32ykPs3aGg7",
            src: "imgs/streetart/leipzig.png",
            alt: "Leipzig",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Vienna
        {
            href: "https://goo.gl/photos/BPurbTi3VbMSPi5b6",
            src: "imgs/streetart/vienna.png",
            alt: "Vienna",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Brno
        {
            href: "https://goo.gl/photos/3xzRewmTqv6CJVL47",
            src: "imgs/streetart/brno.png",
            alt: "Brno",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Chichester
        {
            href: "https://goo.gl/photos/UrY6Ad9xkXRMEqyt5",
            src: "imgs/streetart/chichester.png",
            alt: "Chichester",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Lisbon
        {
            href: "https://goo.gl/photos/3hESSCVBJSjyyL3K7",
            src: "imgs/streetart/lisbon.png",
            alt: "Lisbon",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Frankfurt
        {
            href: "https://goo.gl/photos/FnE2BSYckyeePS5ZA",
            src: "imgs/streetart/frankfurt.png",
            alt: "Frankfurt",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Hamburg
        {
            href: "https://goo.gl/photos/rzKZV3JQSsnPagGz8",
            src: "imgs/streetart/hamburg.png",
            alt: "Hamburg",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Bilbao
        {
            href: "https://goo.gl/photos/exnCh8oed6gr9otr5",
            src: "imgs/streetart/bilbao.png",
            alt: "Bilbao",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Bern
        {
            href: "https://goo.gl/photos/kzB3QxEAzKg25eyu7",
            src: "imgs/streetart/bern.png",
            alt: "Bern",
            className: "image_placeholder",
            containerName: "content_streetart",
        },
        // Fuerteventura
        {
            href: "https://photos.app.goo.gl/ZJja2ZLG4SfsBVEh2",
            src: "imgs/streetart/fuerteventura.png",
            alt: "Fuerteventura",
            className: "image_placeholder",
            containerName: "content_streetart",
        }
    ];

    loadStreetArtImagesSync(data, 0);
};

var loadStreetArtImagesSync = function(data, i) {
    loadStreetArtImage(data, i, function() {
        if (i+1 < data.length) {
            loadStreetArtImagesSync(data, i+1);
        }
    })
};

var loadStreetArtImage = function(data, i, callback) {
    var obj = data[i];
    var container = document.getElementById(obj.containerName);
    var a = document.createElement("a");
    a.href = obj.href;
    a.target = "_blank";
    var img = document.createElement("img");
    img.className = obj.className;
    img.src = obj.src;
    img.alt = obj.alt;
    img.style.visibility="hidden";
    img.onload = function () {
        this.style.visibility="visible";
        if (callback) {
            callback();
        }
    };
    a.appendChild(img);
    container.appendChild(a);
};
